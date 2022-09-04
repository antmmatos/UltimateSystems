$(document).ready(function () {
    let hud = document.getElementById("hud");
    hud.style.left = "25px";
    HealthBar = new ProgressBar.Circle("#health", {
        color: "#ff0000",
        trailColor: "#570000",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    ArmourBar = new ProgressBar.Circle("#armour", {
        color: "#25b800",
        trailColor: "#166e00",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    StaminaBar = new ProgressBar.Circle("#stamina", {
        color: "#ffb700",
        trailColor: "#876100",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    HungerBar = new ProgressBar.Circle("#hunger", {
        color: "#ff8000",
        trailColor: "#944a00",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    ThirstBar = new ProgressBar.Circle("#thirst", {
        color: "#00c3ff",
        trailColor: "#005470",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    VoiceBar = new ProgressBar.Circle("#voice", {
        color: "#ffffff",
        trailColor: "#b3b3b3",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });
    
    FuelBar = new ProgressBar.Circle("#fuel", {
        color: "#a86d00",
        trailColor: "#784e00",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 10,
        easing: "easeInOut",
    });
    
    CarfixBar = new ProgressBar.Circle("#carfix", {
        color: "#fa1414",
        trailColor: "#870101",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 10,
        easing: "easeInOut",
    });
});

window.addEventListener("message", (event) => {
    var data = event.data;
    switch (data.voice) {
        case 1:
            data.voice = 33;
            break;
        case 2:
            data.voice = 66;
            break;
        case 3:
            data.voice = 100;
            break;
        default:
            data.voice = 66;
            break;
    }
    let hud = document.getElementById("hud");
    if (data.setMap) {
        if (data.showMap) {
            hud.style.removeProperty('left');
            hud.style.right = "25px";
        }
        else {
            hud.style.removeProperty('right');
            hud.style.left = "25px";
        }
    }
    if (data.start) {
        if (data.health <= 0) {
            HealthBar.animate(0);
        }
        else {
            HealthBar.animate(data.health / 100);
        }
        ArmourBar.animate(data.armour / 100);
        HungerBar.animate(data.hunger / 100);
        ThirstBar.animate(data.thirst / 100);
        StaminaBar.animate(data.stamina / 100);
        VoiceBar.animate(data.voice / 100);
    } else if (data.refresh) {
        if (data.health <= 0) {
            HealthBar.animate(0);
        }
        else {
            HealthBar.animate(data.health / 100);
        }
        ArmourBar.animate(data.armour / 100);
        HungerBar.animate(data.hunger / 100);
        ThirstBar.animate(data.thirst / 100);
        StaminaBar.animate(data.stamina / 100);
        VoiceBar.animate(data.voice / 100);
    } else if (data.inCar) {
        $("#carhud").fadeIn();
    } else if (data.outCar) {
        $("#carhud").fadeOut();
    } else if (data.isToSetSpeed) {
        var velocidade = document.getElementById("velocidade");
        velocidade.innerHTML = data.setVel;
        FuelBar.animate(data.fuel / 100);
        CarfixBar.animate(data.carfix / 100);
    }
});