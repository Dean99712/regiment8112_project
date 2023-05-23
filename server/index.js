const express = require('express');
const app = express();
const PORT = 3001;
const database = 'mongodb+srv://dean2910997:Enm0vMjJaLLErKgW@cluster0.oriz8e4.mongodb.net/?retryWrites=true&w=majority';
const {google} = require("googleapis");
const request = require("request");
const cors = require("cors");
const urlParse = require("url-parse");
const mongo = require("mongoose")
const bodyParser = require("body-parser");
const axios = require("axios");
const querystring = require("querystring");
const url = require("url");

mongo.connect(database)
    .then(() => {
        console.log('Connected successfully!')
    }).catch(e => {
    console.log(e)
})
app.use(cors());
app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json());

app.get('/', (req, res) => {
    const oauth2Client = new google.auth.OAuth2(
        "643664871038-5cp52r443dticduhhba1ng1lj925ttij.apps.googleusercontent.com",
        "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",
        "http://localhost:3001/photos"
    );
    const scopes = [
        "https://www.googleapis.com/auth/photoslibrary profile email openid",
    ]
    const url = oauth2Client.generateAuthUrl({
        access_type: "offline",
        scope: scopes,
        state: JSON.stringify({
            callbackUrl: req.body.callbackUrl,
            userID: req.body.userid
        })
    })

    request(url, (err, response) => {
        console.log(`error:  ${err}`);
        console.log(`statusCode: ${response && response.statusCode}`);
        res.send({url});
    })

});

app.get('/photos', async (req, res) => {
    const queryURL = new urlParse(req.url);
    const code = querystring.parse(queryURL.query).code;
    const oauth2Client = new google.auth.OAuth2(
        "643664871038-5cp52r443dticduhhba1ng1lj925ttij.apps.googleusercontent.com",
        "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",
        "http://localhost:3001/photos"
    );
    const token = await oauth2Client.getToken(code);
    let photos = [];

    try {
        const result = await axios.get(`https://photoslibrary.googleapis.com/v1/mediaItems`, {
            headers: {
                "Authorization": `Bearer ${token.tokens.access_token}`,
                "Content-Type": "application/json",
            },
        })
        photos = result.data;

    } catch (e) {
        console.log(e);
    }
    // return photos;
});


app.listen(PORT, () => {
    console.log(`Connected to port ${PORT}`)
})