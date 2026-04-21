<?php
header('Content-Type: application/json');
require_once 'db_config.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if ($data) {
    $email = $data['email'];
    $password = $data['password'];

    $sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
    $params = array($email, $password);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        echo json_encode(array("status" => "error", "message" => "Lỗi truy vấn", "errors" => sqlsrv_errors()));
    } else {
        if ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
            echo json_encode(array(
                "status" => "success",
                "message" => "Đăng nhập thành công",
                "user" => $row
            ));
        } else {
            echo json_encode(array("status" => "error", "message" => "Email hoặc mật khẩu không chính xác"));
        }
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Dữ liệu không hợp lệ"));
}

sqlsrv_close($conn);
?>
