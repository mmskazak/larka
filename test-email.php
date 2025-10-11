<?php

use Illuminate\Support\Facades\Mail;

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

Mail::raw('This is a test email from Laravel!', function ($message) {
    $message->to('test@example.com')
            ->subject('Test Email from Larka Project');
});

echo "Test email sent to MailHog!\n";
echo "Check: http://localhost:8025\n";
