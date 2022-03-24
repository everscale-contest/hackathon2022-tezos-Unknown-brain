pragma ton -solidity >=0.40.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "https://raw.githubusercontent.com/tonlabs/debots/main/Debot.sol";
import "../Terminal/Terminal.sol";
import "../Network/Network.sol";
import "../Menu/Menu.sol";

contract Example is Debot {
    function start() public override {
        _menu();
    }

    string netName = "mainnet";
    string publicKey = "";
    string privateKey = "-1";
    string toAddress = "";

    function _menu() private inline {
        Menu.select("Main menu", "Choose Action", [
            MenuItem("Login", "login_here", tvm.functionId(handleLoginMenu)),
            MenuItem("Balance_of_another_people", "check any tezos wallet balance", tvm.functionId(handleMenuBalance)),
            MenuItem("Transaction", "send your money here", tvm.functionId(handleMenuTransaction)),
            MenuItem("Friends", "add friends and sent them moneyy", tvm.functionId(handleMenuFriends)),
            MenuItem("Switch network", "switch network here", tvm.functionId(handleMenuSwitch))
            ]);
    }

    function getFriends() private
    function handleMenuFriends(uint32 index) public {
        Terminal.input(tvm.functionId(setPrivateKey), "Enter privateKey:", false);
    }


    function handleLoginMenu(uint32 index) public {
        Terminal.input(tvm.functionId(setPrivateKey), "Enter privateKey:", false);
    }

    function setPrivateKey(string value) public {
        privateKey = value;
        _menu();
    }

    function handleMenuBalance(uint32 index) public {
        Terminal.input(tvm.functionId(getBalance), "Enter publicKey:", false);
    }

    function handleMenuTransaction(uint32 index) public {
        Terminal.input(tvm.functionId(setToAddress), "Enter publicKey:", false);
    }

    function setToAddress(string value) public {
        toAddress = value;
        Terminal.input(tvm.functionId(transaction), "Enter amount:", false);
    }

    function transaction(string value) public {
        string[] headers;
        headers.push("Content-Type: application/x-www-form-urlencoded");
        string url = "http://localhost:8080/transaction";
        //Todo depends on net
        if (privateKey == "-1") {
            Terminal.print(0, "login first");
            _menu();
        }
        else {
            string body = "privatekey=" + privateKey + "&adress=" + toAddress + "&amount=" + value;
            Network.post(tvm.functionId(setResponse), url, headers, body);}
    }

    function handleMenuSwitch(uint32 index) public {
        Terminal.print(0, "Current Network=" + netName);
        Menu.select("menu for change network", "Choose Action", [
            MenuItem("hangzhounet", "hangzhounet", tvm.functionId(setNetworkHangzhounet)),
            MenuItem("mainnet", "mainnet", tvm.functionId(setNetworkMainnet))
            ]);
    }

    function setNetworkHangzhounet(uint32 index) public {
        Terminal.print(0, "Switched to hangzhounet");
        netName = "hangzhounet";
        _menu();
    }

    function setNetworkMainnet(uint32 index) public {
        Terminal.print(0, "Switched to mainnet ");
        netName = "mainnet";
        _menu();

    }

    function getBalance(string value) public {
        Terminal.print(0, value);
        string[] headers;
        string url = "https://" + netName + ".smartpy.io/chains/main/blocks/head/context/contracts/" + value + "/balance";
        Terminal.print(0, url);
        Network.get(tvm.functionId(setResponse), url, headers);
    }

    function setResponse(int32 statusCode, string[] retHeaders, string content) public {
        require(statusCode == 200, 101);
        // TODO: analyze headers.
        for (string hdr : retHeaders) {
        Terminal.print(0, hdr);
        }
        // TODO: deserialize content from json to structure using Json interface.
        Terminal.print(0, content);
        _menu();

    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [Terminal.ID, Network.ID];
    }

    function getDebotInfo() public functionID(0xDEB) view override returns (
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon) {
        name = "Tezos wallet";
        version = "0.1.0";
        publisher = "Unknown Brain";
        key = "Tezos wallet";
        author = "Unknown Brain";
        support = address(0);
        hello = "Hello, It is a Wallet";
        language = "en";
        dabi = m_debotAbi.get();
        icon = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=";
    }
}

