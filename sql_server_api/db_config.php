<?php
$serverName = "localhost"; // Hoặc địa chỉ IP máy chủ SQL Server
$connectionInfo = array(
    "Database" => "YourDatabaseName", // THAY ĐỔI: Tên database của bạn
    "UID" => "sa",
    "PWD" => "12345",
    "CharacterSet" => "UTF-8"
);

// Kết nối
$conn = sqlsrv_connect($serverName, $connectionInfo);

if (!$conn) {
    echo json_encode(array(
        "status" => "error",
        "message" => "Kết nối thất bại",
        "errors" => sqlsrv_errors()
    ));
    die();
}
?>
