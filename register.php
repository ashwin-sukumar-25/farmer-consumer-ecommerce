<?php
$host = "localhost";
$user = "root"; 
$pass = "root";
$dbname = "farmer_consumer_db";

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$name = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$confirmPassword = $_POST['confirmPassword'] ?? '';
$role = $_POST['role'] ?? '';

if (empty($name) || empty($email) || empty($password) || empty($role)) {
    header("Location: http://localhost:8080/farmer-consumer-ecommerce?message=error");
    exit;
}

if ($password !== $confirmPassword) {
    header("Location: http://localhost:8080/farmer-consumer-ecommerce/register.jsp?message=error");
    exit;
}

$stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    header("Location: http://localhost:8080/farmer-consumer-ecommerce/register.jsp?message=error");
    exit;
}

$hashed = password_hash($password, PASSWORD_DEFAULT);
$stmt = $conn->prepare("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $name, $email, $hashed, $role);

if ($stmt->execute()) {
    header("Location: http://localhost:8080/farmer-consumer-ecommerce/register.jsp?message=success");
} else {
    header("Location: http://localhost:8080/farmer-consumer-ecommerce/register.jsp?message=error");
}

$stmt->close();
$conn->close();
?>
