<?php
// ================= CONFIG =================
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

$midtrans_js_url = $is_production 
    ? 'https://app.midtrans.com/snap/snap.js' 
    : 'https://app.sandbox.midtrans.com/snap/snap.js';


// ================= FUNCTION =================
function create_midtrans_transaction($transaction_data) {
    global $midtrans_server_key, $midtrans_snap_url;

    $curl = curl_init();
    curl_setopt_array($curl, [
        CURLOPT_URL => $midtrans_snap_url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($transaction_data),
        CURLOPT_HTTPHEADER => [
            'accept: application/json',
            'content-type: application/json',
            'authorization: Basic ' . base64_encode($midtrans_server_key . ':')
        ],
    ]);

    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);

    if ($err) {
        return ['error' => 'cURL Error: ' . $err];
    }

    $result = json_decode($response, true);

    if (isset($result['token'])) {
        return ['token' => $result['token']];
    }

    return ['error' => $result['error_messages'][0] ?? 'Unknown error'];
}


// ================= CONTOH DATA =================
$order_id = "ORDER-" . time();

$transaction_data = [
    "transaction_details" => [
        "order_id" => $order_id,
        "gross_amount" => 100000
    ],
    "customer_details" => [
        "first_name" => "User",
        "email" => "user@email.com"
    ]
];


// ================= EXECUTE =================
$result = create_midtrans_transaction($transaction_data);

if (!isset($result['token'])) {
    echo "<h3>Midtrans Error:</h3>";
    echo $result['error'];
    exit;
}

$snap_token = $result['token'];
?>

<!DOCTYPE html>
<html>
<head>
    <title>Midtrans Payment</title>
    <script src="<?= $midtrans_js_url ?>" data-client-key="<?= $midtrans_client_key ?>"></script>
</head>
<body>



<script>
document.getElementById('pay-button').onclick = function () {
    snap.pay("<?= $snap_token ?>", {
        onSuccess: function(result){
            alert("Pembayaran sukses!");
            console.log(result);
        },
        onPending: function(result){
            alert("Menunggu pembayaran...");
            console.log(result);
        },
        onError: function(result){
            alert("Pembayaran gagal!");
            console.log(result);
        }
    });
};
</script>

</body>
</html>