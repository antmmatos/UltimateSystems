<?php
    
    $db_host = "localhost";
    $db_username = "root";  
    $db_password = "";
    $db_database = "d4rkac";
    $return = null;
    $acstate = file_get_contents("manutencao.json");
    $jsonacstate = json_decode($acstate, true);

    function get_license_time(string $license) {
        global $db_host;
        global $db_username;
        global $db_password;
        global $db_database;
        
    
        $db = new mysqli($db_host, $db_username, $db_password, $db_database);
        if ($db->connect_errno) {
            $db->close();
            return "error";
        }
        $query = $db->query("SELECT Tempo FROM licenses WHERE license ='$license'");
        if ($query) {
            $db->close();
                $time_left = (int)$query->fetch_array()[0];
                if ($time_left == -1) {
                    return "Lifetime";
                }

                if ($time_left == 0) {
                    return "Expired";
                }
                return $time_left;
        }
    
        $db->close();
        return "Error";
    }

    function get_client_ip() {
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
          $ip=$_SERVER['HTTP_CLIENT_IP'];
        } else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
          $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
        } else {
          $ip=$_SERVER['REMOTE_ADDR'];
        }
        
        return $ip;
    }

    function get_license(string $license) {

        global $db_host;
        global $db_username;
        global $db_password;
        global $db_database;
        
    
        $db = new mysqli($db_host, $db_username, $db_password, $db_database);
        if ($db->connect_errno) {
            $db->close();
            return "error";
        }


        $query = $db->query("SELECT License FROM licenses WHERE License = '$license'");
        if ($query) {
            if($query->num_rows > 0) {
                return true;
            }
        }
        return false;
    }


    function get_ip_registered(string $license) {
        global $db_host;
        global $db_username;
        global $db_password;
        global $db_database;
        
    
        $db = new mysqli($db_host, $db_username, $db_password, $db_database);
        if ($db->connect_errno) {
            $db->close();
            return "error";
        }

        $query = $db->query("SELECT IP FROM licenses WHERE License = '$license'");
        if ($query) {
            return $query->fetch_array()[0];
        }
    }

    function get_name(string $license) {

        global $db_host;
        global $db_username;
        global $db_password;
        global $db_database;
        
    
        $db = new mysqli($db_host, $db_username, $db_password, $db_database);
        if ($db->connect_errno) {
            $db->close();
            return "error";
        }


        $query = $db->query("SELECT Owner FROM licenses WHERE License = '$license'");
        if ($query) {
            if($query->num_rows > 0) {
                return (string)$query->fetch_array()[0];
            }
        }
    }

    function get_anticheat_state() {
        
        global $jsonacstate;

        if ($jsonacstate['Anticheat']["status"] == "ON") {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        if(get_license($_POST["D4rkLicenseSystem"])) {
            if((get_license_time($_POST["D4rkLicenseSystem"]) != "Expired") && (get_license_time($_POST["D4rkLicenseSystem"]) != "Error")) {
                if((get_ip_registered($_POST["D4rkLicenseSystem"]) == get_client_ip()) || get_ip_registered($_POST["D4rkLicenseSystem"]) == "") {
                    if(get_anticheat_state()) {
                        if(get_ip_registered($_POST["D4rkLicenseSystem"]) == "") {
                            global $db_host;
                            global $db_username;
                            global $db_password;
                            global $db_database;
            
                            $db = new mysqli($db_host, $db_username, $db_password, $db_database);
                            if ($db->connect_errno) {
                                $db->close();
                                return "error";
                            }
                            $db->query("UPDATE licenses SET IP = '".get_client_ip()."' WHERE License = '".$_POST["D4rkLicenseSystem"]."'");
                        }
                        if(get_license_time($_POST["D4rkLicenseSystem"]) == "Lifetime") {
                            echo(get_name($_POST["D4rkLicenseSystem"]) . " | LIFETIME");
                        } else {
                            echo(get_name($_POST["D4rkLicenseSystem"]) . " | " . get_license_time($_POST["D4rkLicenseSystem"]));
                        }
                    } else {
                        echo("Manutencao");
                    }
                } else {
                    echo("InvalidIP");
                }
            } else {
                echo("ExpiredLicense");
            }
        } else {
            echo("InvalidLicense");
        }
    }
?>