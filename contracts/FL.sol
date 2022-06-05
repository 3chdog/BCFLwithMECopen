// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract FL {
    // state variables
    string public global_model_ipfs_url = "gggggg";
    string[] public ipfs_urls;
    string[] public aggregated_model_ipfs_urls;
    mapping(string => uint) public polls;

    // host parameters
    uint rounds = 20;
    uint min_num_server = 4;
    uint min_local_upload_rate = 80; // percent
    uint min_aggr_upload_rate = 80; //percent

    // controll variables
    uint current_round = 0;
    uint num_listener = 0;
    bool[3] public function_locks = [false, false, false]; // function be callable if true
    bool[3] public stage_locks = [false, false, false]; // if stage was pushed in this round
    
    // events
    event go_training();
    event go_aggregate();

    // functions
    //// TODO: check and update listeners (kick if no response)
    //// TODO: sign up
    //// for listener
    function add_listener() public {
        num_listener += 1;
    }
    function get_num_listener() public view returns (uint) {
        return num_listener;
    }

    //// rounds
    function get_cur_round() public view returns (uint) {
        return current_round;
    }

    //// model
    //// local models
    function get_ipfs_urls() view public returns (string[] memory) {
        return ipfs_urls;
    }
    function append_ipfs_url(string memory newUrl) public {
        if (function_locks[0]){
            ipfs_urls.push(newUrl);
        }
    }
    function reset_ipfs_urls() public {
        delete ipfs_urls;
    }
    //// aggregated models
    function get_aggregated_models() view public returns (string[] memory) {
        return aggregated_model_ipfs_urls;
    }
    function append_aggregated_models(string memory newUrl) public {
        if (function_locks[1]){
            aggregated_model_ipfs_urls.push(newUrl);
        }
    }
    function reset_aggregated_models() public {
        delete aggregated_model_ipfs_urls;
    }
    //// global model
    function get_global_model() view public returns (string memory) {
        return global_model_ipfs_url;
    }
    function set_global_model(uint r) public {
        // was called || should wait || local is not sync
        if ((stage_locks[2]) || (num_listener < min_num_server) || (r != current_round)) {
            return;
        }
        // should wait
        else if ((aggregated_model_ipfs_urls.length * 100 < num_listener * min_aggr_upload_rate)) {
            return;
        }
        stage_locks[2] = true;
        function_locks = [false, false, true];
        reset_ipfs_urls();

        // vote
        string[] memory models = get_aggregated_models();
        uint max = 0;
        for(uint i = 0; i < aggregated_model_ipfs_urls.length; i++) {
            polls[models[i]]++;
        }
        for(uint i = 0; i < aggregated_model_ipfs_urls.length; i++) {
            if(polls[models[i]] > polls[models[max]]) {
                max = i;
            }
        }
        for(uint i = 0; i < aggregated_model_ipfs_urls.length; i++) {
            polls[models[i]] = 0;
        }
        global_model_ipfs_url = models[max];
        current_round += 1;
        stage_locks = [false, false, false];
        if (current_round == rounds) {
            num_listener = 0;
        }
    }

    //// event trigger
    function start_next_round(uint r) public {
        // was called || should wait || local is not sync
        if ((stage_locks[0]) || (num_listener < min_num_server) || (r != current_round)) {
            return;
        }
        stage_locks[0] = true;
        reset_aggregated_models();
        function_locks = [true, false, false];
        emit go_training();
    }
    function stop_training(uint r) public {
        // was called || should wait || local is not sync
        if ((stage_locks[1]) || (num_listener < min_num_server) || (r != current_round)) {
            return;
        }
        // should wait
        else if ((ipfs_urls.length * 100 < num_listener * min_local_upload_rate)) {
            return;
        }
        stage_locks[1] = true;
        function_locks = [false, true, false];
        emit go_aggregate();
    }

    //// locks
    //// function locks
    function get_function_locks() public view returns (bool[3] memory) {
        return function_locks;
    }
    //// stage locks
    function get_stage_locks() public view returns (bool[3] memory) {
        return stage_locks;
    }
}