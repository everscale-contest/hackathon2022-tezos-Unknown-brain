npx everdev se reset
npx everdev se start
npx everdev network default se
npx everdev signer add giver 172af540e43a524763dd53b26a066d472a97c4de37d5498170564510608250c3 -f
npx everdev network giver se 0:b5e9240fc2d2f1ff8cbb1d1dee7fb7cae155e5f6320e585fcc685698994a19a5 --signer giver
npx everdev signer delete coder
npx everdev signer generate coder
npx everdev signer default giver
npx everdev signer list 
npx everdev sol compile App.sol
npx everdev contract deploy --network se --value 1000000000 App
npx everdev contract info --network se --signer giver App
appAddress=$(npx everdev contract info --network se --signer coder App | grep Address | cut -d ' ' -f 4)
echo $appAddress
everdev signer add alice "orange hollow stem useless tennis desk burst fan snack control elder screen" -f
npx everdev signer info alice
npx everdev contract info App
