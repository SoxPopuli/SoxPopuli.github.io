import { Elm } from "../src/Main.elm"
// import * as classes from "./style.scss"

function setCssColors(theme) {
    var root = document.querySelector(":root");
    root?.setAttribute('class', theme);
}
setCssColors('dark');

var app = Elm.Main.init({
    node: document.getElementById('root')
});


app.ports.setTheme_.subscribe(theme => {
    console.log(`Setting theme: ${theme}`);
    setCssColors(theme);
});