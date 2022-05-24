// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract FL {
    // variables
    address[] public members;
    address[] public tmp_members;
    string[] public roles;
    string[] public tmp_roles;
    string[] public ipfs_urls;
    string[] public aggregated_model_ipfs_urls;
    mapping(string => uint) public polls;
    string public global_model_ipfs_url = "QmTtvUpZcChmbKf2L2gexxxBbNwAvjhLBRHj4MVY1rqgHy";
    bool[3] public function_locks = [false, false, false];

    // events
    event go_training();
    event go_aggregate();

    // functions
    //// group and roles TODO: multi-groups
    function join_a_group() public {
        members.push(msg.sender);
        // TODO: assign roles
        if (roles.length < 1) {
            roles.push("host");
        } else if (roles.length < 3) {
            roles.push("aggregator");
        } else {
            roles.push("worker");
        }
    }
    function check_in_group(address myAddress) public view returns (bool) {
        for (uint i=0; i < members.length; i++){
            if (members[i] == myAddress) {
                return true;
            }
        }
        return false;
    }
    function leave_a_group(address myAddress) public {
        delete tmp_members;
        delete tmp_roles;
        string memory leaved_role = "";
        for (uint i=0; i < members.length; i++){
            if (members[i] != myAddress) {
                tmp_members.push(members[i]);
                tmp_roles.push(roles[i]);
            } else {
                leaved_role = roles[i];
            }
        }
        delete members;
        delete roles;
        members = tmp_members;
        roles = tmp_roles;
        delete tmp_members;
        delete tmp_roles;
        // TODO: check and change_role
        if ((keccak256(bytes(leaved_role)) == keccak256(bytes("host"))) || (keccak256(bytes(leaved_role)) == keccak256(bytes("aggregator")))) {
            for (uint i=0; i < members.length; i++){
                if (keccak256(bytes(roles[i])) == keccak256(bytes("worker"))) {
                    change_role(members[i], leaved_role);
                    break;
                }
            }
        }
        leaved_role = "";
    }
    function num_members() view public returns (uint) {
        return members.length;
    }
    function change_role(address myAddress, string memory newRole) public {
        for (uint i=0; i < members.length; i++){
            if (members[i] == myAddress) {
                roles[i] = newRole;
            }
        }
    }
    function get_role(address myAddress) public view returns (string memory){
        for (uint i = 0; i < members.length; i++) {
            if (myAddress == members[i]) {
                return roles[i];
            }
        }
        return "";
    }
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
        if ((keccak256(bytes(get_role(msg.sender))) == keccak256(bytes("host"))) || (keccak256(bytes(get_role(msg.sender))) == keccak256(bytes("aggregator")))) {
            if (function_locks[1]){
                aggregated_model_ipfs_urls.push(newUrl);
            }
        }
    }
    function reset_aggregated_models() public {
        delete aggregated_model_ipfs_urls;
    }
    //// global model
    function get_global_model() view public returns (string memory) {
        return global_model_ipfs_url;
    }
    function set_global_model() public {
        if ((keccak256(bytes(get_role(msg.sender))) == keccak256(bytes("host")))) {
            function_locks = [false, false, true];
            reset_ipfs_urls();
            // TODO: how to vote
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
        }
    }
    //// event trigger TODO: only host can call these functions
    function start_next_round(bool callEvent) public {
        if (callEvent && (keccak256(bytes(get_role(msg.sender))) == keccak256(bytes("host")))) {
            reset_aggregated_models();
            function_locks = [true, false, false];
            emit go_training();
        }
    }
    function stop_training(bool callEvent) public {
        if (callEvent && (keccak256(bytes(get_role(msg.sender))) == keccak256(bytes("host")))) {
            function_locks = [false, true, false];
            emit go_aggregate();
        }
    }
}