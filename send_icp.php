<?php
/**
 * php 使用钉钉机器人发送消息.
 * User: Administrator
 * Date: 2019/8/29
 * Time: 23:40
 */
header("Content-type:text/html;charset=utf-8");
//curl请求
function httpGet($url) {
    $ch = curl_init();
    //设置选项，包括URL
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    //执行并获取HTML文档内容
    $output = curl_exec($ch);
    //释放curl句柄
    curl_close($ch);
    //打印获得的数据
    return $output;
}



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

$webhook = "https://oapi.dingtalk.com/robot/send?access_token=6a475a0967873d701fc06f2bdcb1c52ffcb303c9ff4c7c473e9a284e79293192";

$domain = 'p6071.com';
$url = "https://api.ooopn.com/icp/api.php?url={$domain}";

$res = httpGet($url);
//echo '<pre>';print_r($res);die;
$res = json_decode($res,1);

if($res['code'] != 200)
{
    $content = $res['msg'];
    // text类型
    $textString = json_encode([
        'msgtype' => 'text',
        'text' => [
            "content" => "{$domain}---{$content}"
        ],
        'at' => [
            'atMobiles' => [
                // "156xxxx8827",
                //  "189xxxx8325"
            ],
            'isAtAll' => false

        ]
    ]);

}



$result = request_by_curl($webhook, $textString);
echo $result;
