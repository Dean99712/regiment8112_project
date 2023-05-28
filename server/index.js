const express = require('express');
const app = express();
const PORT = 3001;
const database = 'mongodb+srv://dean2910997:Enm0vMjJaLLErKgW@cluster0.oriz8e4.mongodb.net/?retryWrites=true&w=majority';
const mongo = require("mongoose")
const {google} = require("googleapis");
const request = require("request");
const cors = require("cors");
const urlParse = require("url-parse");
const bodyParser = require("body-parser");
const axios = require("axios");
const querystring = require("querystring");
const url = require("url");
const {initializeApp} = require('firebase/app');
const {getStorage, ref, getDownloadURL, uploadBytesResumable, uploadString } = require('firebase/storage');
const {firebaseConfig} = require("./config");


mongo.connect(database)
    .then(() => {
        console.log('Connected successfully!')
    }).catch(e => {
    console.log(e)
})
app.use(cors());
app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json());

initializeApp(firebaseConfig);
const storage = getStorage();

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

    let photos = {};

    let albumId;
    let albumTitle;

    try {
        const result = await axios.get(`https://photoslibrary.googleapis.com/v1/albums`, {
            // const result = await axios.get(`https://photoslibrary.googleapis.com/v1/mediaItems?pageSize=100`, {
            headers: {
                "Authorization": `Bearer ${token.tokens.access_token}`,
                "Content-Type": "application/json",
            },
        })

        const albums = result?.data?.albums;

        const album = albums.map(album => {
            return {
                id: album?.id,
                title: album?.title
            };
        })

        albumId = album[0]?.id;
        console.log(albumId)
        albumTitle = "קו אביטל 23";

    } catch (e) {
        console.log(e);
    }
    try {
        const result = await axios.post(`https://photoslibrary.googleapis.com/v1/mediaItems:search?pageSize=100`,
            {
                albumId: albumId
            }, {
                headers: {
                    "Authorization": `Bearer ${token.tokens.access_token}`,
                    "Content-Type": "application/json",
                },
            });
        photos = result?.data?.mediaItems

        const baseUrl = photos.map(photo => {
            return photo?.baseUrl
        })

        await uploadPhotos(baseUrl, albumTitle)

    } catch (e) {
        console.log(e.message)
    }
});


const uploadPhotos = async (photo, albumName) => {
    const storageRef = ref(storage, `images/albums/${albumName}/${photo}`);
    uploadString(storageRef, photo)
        .then((url) => {
            console.log(url)
        })

}


app.listen(PORT, () => {
    console.log(`Connected to port ${PORT}`)
})