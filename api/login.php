<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

// Connexion à la base de données avec PDO ---
require_once('api_db_connect.php');


// Récupération des valeurs envoyées par l'application externe
$email = $_POST["email"];
$password = $_POST["password"];

/*
// Requête pour vérifier si les valeurs correspondent à celles de la base de données
$sql = $pdo->prepare("SELECT * FROM users WHERE email=:email AND password=:password");
$sql->execute(['email' => $email, 'password' => $password]);
$count = $sql->rowCount();

// Affichage du message de succès ou d'erreur sous forme de tableau JSON
if ($count > 0) {
    $json = array("status" => 200, "message" => "Success");
    $json = array_merge($json, $sql->fetch());
    unset($json['password']);
    $json['token']='generateSomeToken';
} else {
    $json = array("status" => 400, "message" => "Error");
}
*/

$sql = $pdo->prepare("SELECT * FROM users WHERE email=:email");
$sql->execute(['email' => $email]);
$user = $sql->fetch();

if ($user && password_verify($password, $user['password'])) {
    $json = array("status" => 200, "message" => "Success");
    unset($json['password']);
    $json['token']='generateSomeToken';
} else {
    $json = array("status" => 400, "message" => "Error");
}


echo json_encode($json);

// Fermeture de la connexion à la base de données
$pdo = null;
