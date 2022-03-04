"use strict";
exports.__esModule = true;
var taquito_1 = require("@taquito/taquito");
var signer_1 = require("@taquito/signer");
var rpc_server = "https://hangzhounet.smartpy.io";
var bodyParser = require('body-parser');
var cors = require("cors");
function transfer_money(privateKey, adress, amount) {
    var Tezos = new taquito_1.TezosToolkit(rpc_server);
    Tezos.setProvider({
        signer: new signer_1.InMemorySigner(privateKey)
    });
    (0, signer_1.importKey)(Tezos, privateKey);
    return Tezos.contract
        .transfer({ to: adress, amount: amount })
        .then(function (op) {
        console.log("Waiting for ".concat(op.hash, " to be confirmed..."));
        return op.confirmation(1).then(function () { return op.hash; });
    })
        .then(function (hash) { return console.log("Operation injected: ".concat(rpc_server, "/").concat(hash)); });
}
var server = require("express");
var app = server();
var port = 8080;
app.use(bodyParser.urlencoded());
app.get("/health_check", function (req, res) {
    res.send("server is alive!");
});
app.post("/", function (req, answer) {
    console.log(req);
});
app.get("/", function (req, answer) {
    console.log(req);
});
app.post("/transaction", function (req, answer) {
    console.log(req.body);
    var private_key = req.body["privatekey"];
    var adress = req.body["adress"];
    var amount = req.body["amount"];
    console.log(private_key, adress, amount);
    var res = transfer_money(private_key, adress, amount);
    answer.header("Access-Control-Allow-Origin", "*");
    res
        .then(function () {
        console.log("sucess");
        answer.send("sucess!");
    })["catch"](function (error) {
        console.log("warning:");
        console.log("error:", error);
        answer.send("not sucess!");
    });
});
app.use(function (err, req, res, next) {
    console.error(err.stack);
    console.log("!!!");
    res.header("Access-Control-Allow-Origin", "*");
    res.status(200).send('Something broke!');
});
// start the Express server
app.listen(port, function () {
    console.log("server started at http://localhost:".concat(port));
});
