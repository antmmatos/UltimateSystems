<?php

$db_host = "localhost";
$db_username = "root";
$db_password = "";
$db_database = "ultimatesystems";
$FileLoaded = file_get_contents("status.json");
$State = json_decode($FileLoaded, true);

function GetLicenseTime(string $license)
{
    $db = MySQLConnection();
    $query = $db->query("SELECT Tempo FROM licenses WHERE license ='$license'");
    if ($query) {
        $time_left = (int)$query->fetch_array()[0];
        if ($time_left == -1) {
            return "Lifetime";
        }

        if ($time_left == 0) {
            return "Expired";
        }

        return $time_left;
    }
}

function GetIP()
{
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        return $_SERVER['HTTP_CLIENT_IP'];
    } else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        return $_SERVER['HTTP_X_FORWARDED_FOR'];
    } else {
        return $_SERVER['REMOTE_ADDR'];
    }
}

function CheckLicense(string $license)
{
    $db = MySQLConnection();
    $query = $db->query("SELECT License FROM licenses WHERE License = '$license'");
    if ($query) {
        if ($query->num_rows > 0) {
            return true;
        }
    }
    return false;
}


function GetLicenseIP(string $license)
{
    $db = MySQLConnection();
    $query = $db->query("SELECT IP FROM licenses WHERE License = '$license'");
    if ($query) {
        return $query->fetch_array()[0];
    }
}

function GetOwnerName(string $license)
{
    $db = MySQLConnection();
    $query = $db->query("SELECT Owner FROM licenses WHERE License = '$license'");
    if ($query) {
        if ($query->num_rows > 0) {
            return (string)$query->fetch_array()[0];
        }
    }
}

function GetScriptState(string $script)
{
    global $State;
    if ($State[$script]["status"] == "ON") {
        return true;
    } else {
        return false;
    }
}

function CheckLicenseScript(string $license)
{
    $db = MySQLConnection();
    $query = $db->query("SELECT Script FROM licenses WHERE License = '$license'");
    if ($query) {
        if ($query->num_rows > 0) {
            return (string)$query->fetch_array()[0];
        }
    }
}

function CheckValidDatabase()
{
    $db = MySQLConnection();
    if ($db == false) {
        return false;
    }
    return true;
}

function MySQLConnection()
{
    global $db_host;
    global $db_username;
    global $db_password;
    global $db_database;

    $db = new mysqli($db_host, $db_username, $db_password, $db_database);
    if ($db->connect_errno) {
        $db->close();
        return false;
    }
    return $db;
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $data = new stdClass();
    if (!CheckValidDatabase()) {
        $data->Error = "Authentication Error";
        $encodedData = json_encode($data);
        echo $encodedData;
        return;
    }
    if (CheckLicense($_POST["License"])) {
        if ((GetLicenseTime($_POST["License"]) != "Expired")) {
            if ((GetLicenseIP($_POST["License"]) == GetIP()) || GetLicenseIP($_POST["License"]) == "") {
                if (CheckLicenseScript($_POST["License"]) == $_POST["Script"]) {
                    if (GetScriptState($_POST["Script"])) {
                        if (GetLicenseIP($_POST["License"]) == "") {
                            $db = MySQLConnection();
                            $db->query("UPDATE licenses SET IP = '" . GetIP() . "' WHERE License = '" . $_POST["License"] . "'");
                        }
                        $data->OwnerName = GetOwnerName($_POST["License"]);
                        $data->Version = $State[$_POST["Script"]]["version"];
                        $data->Script = $_POST["Script"];
                        if (GetLicenseTime($_POST["License"]) == "Lifetime") {
                            $data->isLifetime = true;
                        } else {
                            $data->TimeLeft = GetLicenseTime($_POST["License"]);
                        }
                        $encodedData = json_encode($data);
                        echo $encodedData;
                    } else {
                        $data->Error = "Maintenance";
                        $encodedData = json_encode($data);
                        echo $encodedData;
                    }
                } else {
                    $data->Error = "Invalid Script";
                    $encodedData = json_encode($data);
                    echo $encodedData;
                }
            } else {
                $data->Error = "Invalid IP";
                $encodedData = json_encode($data);
                echo $encodedData;
            }
        } else {
            $data->Error = "Expired License";
            $encodedData = json_encode($data);
            echo $encodedData;
        }
    } else {
        $data->Error = "Invalid License";
        $encodedData = json_encode($data);
        echo $encodedData;
    }
}
