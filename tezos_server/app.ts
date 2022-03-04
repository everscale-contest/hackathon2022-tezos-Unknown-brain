import { TezosToolkit } from "@taquito/taquito";
import { InMemorySigner, importKey } from "@taquito/signer";
import express, { Request, Response } from "express";
const rpc_server = "https://hangzhounet.smartpy.io";
var bodyParser = require('body-parser');
const cors=require("cors");

function transfer_money(privateKey, adress, amount) {
  const Tezos = new TezosToolkit(rpc_server);
  Tezos.setProvider({
    signer: new InMemorySigner(privateKey),
  });
  importKey(Tezos, privateKey);
  return Tezos.contract
    .transfer({ to: adress, amount: amount })
    .then((op) => {
      console.log(`Waiting for ${op.hash} to be confirmed...`);
      return op.confirmation(1).then(() => op.hash);
    })
    .then((hash) => console.log(`Operation injected: ${rpc_server}/${hash}`));
}

const server = require("express");
const app = server();
const port = 8080;
app.use(bodyParser.urlencoded());

app.get("/health_check", (req, res) => {
  res.send("server is alive!");
});

app.post("/", (req: Request, answer: Response) => {
  console.log(req)

  });
  app.get("/", (req: Request, answer: Response) => {
    console.log(req)

    });


app.post("/transaction", (req: Request, answer: Response) => {
  console.log(req.body);
  var private_key = req.body["privatekey"];
  var adress = req.body["adress"];
  var amount = req.body["amount"];
  console.log(private_key, adress, amount);
  var res = transfer_money(private_key, adress, amount);
  answer.header("Access-Control-Allow-Origin", "*")

  res
    .then(() => {
      console.log("sucess");
      answer.send("sucess!");
    })
    .catch((error) => {
      console.log("warning:");
      console.log("error:", error);
      answer.send("not sucess!");
    });
});
app.use(function(err, req, res, next) {
  console.error(err.stack);
  console.log("!!!");
  res.header("Access-Control-Allow-Origin", "*")
  res.status(200).send('Something broke!');
});

// start the Express server
app.listen(port, () => {
  console.log(`server started at http://localhost:${port}`);
});
