
window.addEventListener("message", function(event){
    let data = event.data
    if (data.type === "open") {
        document.body.style.display = "block";
        document.getElementById("bordogale").innerHTML = "Tu ai: " + data.portocale;
    }
});

$(document).ready(function(){
    document.onkeyup = function (data) {
        if (data.which == 27 ) {
        document.body.style.display = "none";
        $.post('http://VDScripts_portocale/inchide', JSON.stringify({}));
        }
    };

});

function buy(nutecred,val) {
    $.post('http://VDScripts_portocale/buy', JSON.stringify({val: val, men:nutecred}));
}