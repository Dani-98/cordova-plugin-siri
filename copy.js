const fs = require("fs");
const fse = require("fs-extra");
const child_process = require("child_process");

//ruta a la carpeta que contiene el plugin compilado
let rutaPluginCompilado = "../ionic-native/dist/@ionic-native/siri";

//ruta del node_modules del proyecto donde se va a usar el plugin
let rutaDestino = "../app-clientes/node_modules/@ionic-native/siri";

if (fs.existsSync(rutaPluginCompilado)){
    fse.copySync(rutaPluginCompilado, rutaDestino);
    console.log("Se ha copiado el plugin correctamente");
} else {
    console.log("La carpeta del plugin compilado no existe");
}