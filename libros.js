
const idBuscarTitulo=document.getElementById("id_buscar_titulo");
const idBuscarAutor=document.getElementById("id_buscar_autor");
const idBuscarBoton = document.getElementById("id_boton_buscar");

if(idBuscarTitulo.value === "" && idBuscarAutor.value === "") {
    idBuscarBoton.disabled=true
}

idBuscarTitulo.addEventListener("input", () => {
    if(idBuscarTitulo.value==="") {
        idBuscarBoton.disabled=true;
    }
    else {
        idBuscarBoton.disabled=false;
    }
    if(idBuscarAutor!=="") {
        idBuscarBoton.disabled=false;
    }

    if(idBuscarTitulo.value==="" && idBuscarAutor.value==="") {
        idBuscarBoton.disabled=true
    }
})


idBuscarAutor.addEventListener("input", () => {
    if(idBuscarAutor.value==="") {
        idBuscarBoton.disabled=true;
    }
    else {
        idBuscarBoton.disabled=false;
    }

    if(idBuscarTitulo!=="") {
        idBuscarBoton.disabled = false;
    }
    if(idBuscarTitulo.value==="" && idBuscarAutor.value==="") {
        idBuscarBoton.disabled=true
    }
})