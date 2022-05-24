pragma solidity >=0.5.12<=0.9.0;

contract Shipping
{
    // Our predefined values for shipping listed as enums
    enum ShippingStatus { Pending, Shipped, Delivered }

    // Save enum ShippingStatus in variable status
    ShippingStatus private status;

    int[5] myParams = [int(10),20,33,-140,110001204184];

    // Event to launch when package has arrived
    event LogNewAlert(string description);
    
    event StoreParameters(int[5] params);
    event StoreIPFSsite(string ipfsSite);

    // This initializes our contract state (sets enum to Pending once the program starts)
    constructor() public {
        status = ShippingStatus.Pending;
    }
    // Function to change to Shipped
    function Shipped() public {
        status = ShippingStatus.Shipped;
        emit LogNewAlert("Your package has been shipped");
    }

    // Function to change to Delivered
    function Delivered() public {
        status = ShippingStatus.Delivered;
        emit LogNewAlert("Your package has arrived");
    }

    function UploadParameters() public {
        status = ShippingStatus.Pending;
        emit StoreParameters(myParams);
    }
    
    function UploadSite(string memory ipfsSite) public{
        status = ShippingStatus.Pending;
        emit StoreIPFSsite(ipfsSite);
    }
    
    function UploadArray(int[5] memory myparams) public{
        status = ShippingStatus.Pending;
        emit StoreParameters(myparams);
    }
    // Function to get the status of the shipping
    function getStatus(ShippingStatus _status) internal pure returns (string memory) {
     // Check the current status and return the correct name
     if (ShippingStatus.Pending == _status) return "Pending";
     if (ShippingStatus.Shipped == _status) return "Shipped";
     if (ShippingStatus.Delivered == _status) return "Delivered";
    }

   // Get status of your shipped item
    function Status() public view returns (string memory) {
         ShippingStatus _status = status;
         return getStatus(_status);
    }

}