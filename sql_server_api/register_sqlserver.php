<?php
header('Content-Type: application/json');
require_once 'db_config.php';

// Lấy dữ liệu từ raw body (JSON)
$json = file_get_contents('php://input');
$data = json_decode($json, true);

if ($data) {
    $firstName = $data['first_name'];
    $lastName = $data['last_name'];
    $email = $data['email'];
    $password = $data['password']; // Nên hash mật khẩu trước khi lưu
    $role = $data['role'];
    $country = isset($data['country']) ? $data['country'] : '';

    // Câu lệnh SQL (Sử dụng parameterized query để tránh SQL Injection)
    $sql = "INSERT INTO Users (FirstName, LastName, Email, Password, Role, Country) VALUES (?, ?, ?, ?, ?, ?)";
    $params = array($firstName, $lastName, $email, $password, $role, $country);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt) {
        echo json_encode(array("status" => "success", "message" => "Đăng ký thành công"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Lỗi thực thi truy vấn", "errors" => sqlsrv_errors()));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Dữ liệu không hợp lệ"));
}

sqlsrv_close($conn);
?>
