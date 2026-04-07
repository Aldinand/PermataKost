<?php
// ✅ FIX SESSION (biar ga dobel)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once 'config/database.php'; // koneksi $pdo

// ================= MIDTRANS CONFIG =================
$is_production = false;

$midtrans_client_key = $is_production 
    ? 'YOUR_PRODUCTION_CLIENT_KEY' 
    : 'SB-Mid-client-TXNqPL_AVexaGvGr';

$midtrans_server_key = $is_production 
    ? 'YOUR_PRODUCTION_SERVER_KEY' 
    : 'SB-Mid-server-Q_WOMulvwSXfwpw5-4T616K-';

$midtrans_snap_url = $is_production 
    ? 'https://app.midtrans.com/snap/v1/transactions' 
    : 'https://app.sandbox.midtrans.com/snap/v1/transactions';

// ================= FUNCTION =================
function create_midtrans_transaction($data, $server_key, $url) {
    $curl = curl_init();
    curl_setopt_array($curl, [
        CURLOPT_URL => $url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($data),
        CURLOPT_HTTPHEADER => [
            'Content-Type: application/json',
            'Authorization: Basic ' . base64_encode($server_key . ':')
        ],
    ]);

    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);

    if ($err) {
        return ['error' => $err];
    }

    $result = json_decode($response, true);

    if (isset($result['token'])) {
        return ['token' => $result['token']];
    }

    return ['error' => $result['error_messages'][0] ?? 'Midtrans error'];
}

// ================= VALIDASI =================
if (!isset($_SESSION['user_id'])) {
    die("User belum login");
}

$room_id = intval($_GET['id'] ?? 0);
$user_id = $_SESSION['user_id'];

// ================= GET DATA =================
$stmt = $pdo->prepare("SELECT * FROM rooms WHERE id=? AND status='available'");
$stmt->execute([$room_id]);
$room = $stmt->fetch();

if (!$room) die("Room tidak tersedia");

$stmt = $pdo->prepare("SELECT * FROM users WHERE id=?");
$stmt->execute([$user_id]);
$user = $stmt->fetch();

// ================= TRANSACTION =================
$pdo->beginTransaction();

try {
    // insert tenant
    $stmt = $pdo->prepare("
        INSERT INTO tenants (user_id, room_id, start_date, status) 
        VALUES (?, ?, NOW(), 'active')
    ");
    $stmt->execute([$user_id, $room_id]);
    $tenant_id = $pdo->lastInsertId();

    // update room
    $pdo->prepare("UPDATE rooms SET status='occupied' WHERE id=?")
        ->execute([$room_id]);

    // order id
    $order_id = "ORDER-" . time();

    // insert payment
    $stmt = $pdo->prepare("
        INSERT INTO payments (tenant_id, amount, status, order_id) 
        VALUES (?, ?, 'unpaid', ?)
    ");
    $stmt->execute([$tenant_id, $room['price'], $order_id]);
    $payment_id = $pdo->lastInsertId();

    // ================= MIDTRANS =================
    $transaction_data = [
        "transaction_details" => [
            "order_id" => $order_id,
            "gross_amount" => (int)$room['price']
        ],
        "customer_details" => [
            "first_name" => $user['first_name'],
            "email" => $user['email']
        ]
    ];

    $result = create_midtrans_transaction($transaction_data, $midtrans_server_key, $midtrans_snap_url);

    if (!isset($result['token'])) {
        throw new Exception($result['error']);
    }

    $snap_token = $result['token'];

    // simpan token
    $pdo->prepare("UPDATE payments SET midtrans_token=? WHERE id=?")
        ->execute([$snap_token, $payment_id]);

    $pdo->commit();

} catch (Exception $e) {
    $pdo->rollBack();
    die("Error: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Bayar</title>
    <script src="<?= $is_production ? 'https://app.midtrans.com/snap/snap.js' : 'https://app.sandbox.midtrans.com/snap/snap.js' ?>"
            data-client-key="<?= $midtrans_client_key ?>"></script>
</head>
<body>

<h2>Booking Berhasil</h2>
<p>Kamar: <?= htmlspecialchars($room['name']) ?></p>
<p>Total: Rp <?= number_format($room['price']) ?></p>

<button id="pay">Bayar Sekarang</button>

<script>
document.getElementById('pay').onclick = function () {
    snap.pay("<?= $snap_token ?>", {
        onSuccess: function(){
            alert("Pembayaran sukses!");
            window.location = "index.php?page=dashboard";
        },
        onPending: function(){
            alert("Menunggu pembayaran...");
        },
        onError: function(){
            alert("Pembayaran gagal!");
        }
    });
};
</script>

</body>
</html>