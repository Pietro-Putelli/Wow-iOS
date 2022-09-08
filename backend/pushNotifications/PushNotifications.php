<?php

    class PushNotifications {

        private static $passphrase = '123';

        public function __construct() {
            exit('Init function is not allowed');
        }

        public static function iOS($data, $devicetoken, $user_data) {

            $deviceToken = $devicetoken;
            $ctx = stream_context_create();
            
            // ck.pem is your certificate file
            
            stream_context_set_option($ctx, 'ssl', 'local_cert', 'pushcert.pem');
            stream_context_set_option($ctx, 'ssl', 'passphrase', self::$passphrase);
            
            // Open a connection to the APNS server
            
            $fp = stream_socket_client(
                'ssl://gateway.sandbox.push.apple.com:2195', $err,
                $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
                
            if (!$fp) {
                exit("Failed to connect: $err $errstr" . PHP_EOL);
            }
            
            // Create the payload body
            $body['aps'] = array(
                'alert' => array(
                    'title' => $data['mtitle'],
                    'body' => $data['mdesc'],
                ),
                'sound' => 'default'
            );
            
            $body['data'] = $user_data;
            
            $payload = json_encode($body);
            $msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;
            $result = fwrite($fp, $msg, strlen($msg));

            fclose($fp);
            if (!$result) {
                return 'Message not delivered' . PHP_EOL;
            }
            else {
                return 'Message successfully delivered' . PHP_EOL;
            }
        }

        // Curl
        private function useCurl(&$model, $url, $headers, $fields = null) {
            // Open connection
            $ch = curl_init();
            if ($url) {
                // Set the url, number of POST vars, POST data
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                // Disabling SSL Certificate support temporarly
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                if ($fields) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
                }

                // Execute post
                $result = curl_exec($ch);
                if ($result === FALSE) {
                    die('Curl failed: ' . curl_error($ch));
                }

                // Close connection
                curl_close($ch);

                return $result;
            }
        }
    }
    
    $msg_payload = array (
        'mtitle' => 'Test push notification title',
        'mdesc' => 'Test push notification body',
    );
