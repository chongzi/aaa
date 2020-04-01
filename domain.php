<?php



define("NOTIFY_DAYS", 30);

$domains = array(

   // '6071.com',
   // 'chinaz.com',
    'tuitui99.com'
);

function request_by_curl($remote_server, $post_string)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $remote_server);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json;charset=utf-8'));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    // 不用开启curl证书验证
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
    $data = curl_exec($ch);
    //$info = curl_getinfo($ch);
    //var_dump($info);
    curl_close($ch);
    return $data;
}

function alert($domain,$days,$exp_date)
{

    $webhook = "https://oapi.dingtalk.com/robot/send?access_token=6a475a0967873d701fc06f2bdcb1c52ffcb303c9ff4c7c473e9a284e79293192";
    $content = "{$domain}域名还有{$days}天过期\n";
    $content .= "过期时间:{$exp_date}";
    // text类型
    $textString = json_encode([
        'msgtype' => 'text',
        'text' => [
            "content" => "{$content}"
        ],
        'at' => [
            'atMobiles' => [
                // "156xxxx8827",
                //  "189xxxx8325"
            ],
            'isAtAll' => false

        ]
    ]);
    $result = request_by_curl($webhook, $textString);
    echo $result;
}





function check_doamin_expire($domain)

{


  //  curl_post();

    exec(sprintf("/usr/bin/whois %s", $domain), $arr, $retCode);
    echo '<pre>';
  //  print_r($arr);
  //  echo '----------<br>';
  //  print_r($retCode);
    var_dump($retCode,$arr);die;


    if ($retCode == 0)

    {
        $content = join('',$arr);
      //  var_dump($content);die;
        $patterns = array (
            '/Registry Expiry Date:\s*([^\s]+)\s+/isU',
        );

        foreach($patterns as $pattern)
        {

            if(preg_match($pattern,$content,$a))
            {
                $exp_date = $a[1];
                $remain_time = strtotime($exp_date) - time();
                $days = intval($remain_time/86400);

                alert($domain,$days,$exp_date);
                exit();

                if ( $remain_time < NOTIFY_DAYS*86400)

                {

                    alert($domain,$days,$exp_date);
                    exit();

                }
            }

        }




    }

}



foreach ($domains as $domain)

{

    check_doamin_expire($domain);

}
