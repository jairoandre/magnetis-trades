'use strict';

require('./src/Styles/Default.less');
var Elm = require('./src/Main.elm');

Elm.Main.embed(document.getElementById('main'));
