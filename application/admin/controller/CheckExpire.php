<?php
namespace app\admin\controller;
use think\Controller;
use struct\Tree;
use think\Cache;

//过期时间每天检测一次
class CheckExpire extends Controller
{

    private $webhook = "https://oapi.dingtalk.com/robot/send?access_token=8fcef16a74469670df6e17361171a631ec8326590d403ecafe13dc7e84ee45d2";
    private $textString = [];
    private $notify_days = 10; //10天内到期提醒
    private $isAlert = 0; // 0正常  1报警

    function __construct()
    {
        set_time_limit(1200);
        header("Content-type:text/html;charset=utf-8");

        if ( strpos($_SERVER['HTTP_USER_AGENT'], 'yangcheng') === false ) {
            die('非法访问');
        }

        // text类型
        $this->textString = [
            'msgtype' => 'text',
            'text' => [
                "content" => ""
            ],
            'at' => [
                'atMobiles' => [
                    // "156xxxx8827",
                    //  "189xxxx8325"
                ],
                'isAtAll' => false
            ]
        ];


    }




    //检测域名过期时间
    public function expire(){
        $t1 = time();
        $logPath = LOG_PATH.'expire_'.date('Ymd').'.log';
        $logStr = '------------------------------'."\r\n".date('Y-m-d H:i:s')."\r\n";
        $logStr .= '已检测域名:'."\t";

        while(1)
        {
            $min_id = Cache::get('expire_min_id');
            $min_id = $min_id ? $min_id : 0;
            $where['id'] = array('gt',$min_id);
            $domain_list = model('domain')->listBy($where,$field='*',$limit=1000,$order='id asc');
            if($domain_list)
            {
                foreach($domain_list as $row)
                {
                    $domain = $row['domain'];
                    $this->check_doamin_expire($domain);
                    Cache::set('expire_min_id',$row['id']);
                    $logStr .= " {$domain} |";
                }
            }
            else{
                $t2 = time();
                $logStr .=  "\r\n运行时间:". ($t2 - $t1) . "s\r\n";
                error_log($logStr,3,$logPath);
                Cache::set('expire_min_id',null); //重置

                //正常提醒
                if($this->isAlert == 0)
                {
                    $this->textString['text']['content'] = "域名到期监测正常";

                   // echo '<pre>'.json_encode($this->textString);

                    $result = $this->request_by_curl($this->webhook, json_encode($this->textString));
                   // var_dump($result);
                }

                exit();
            }
        }

        exit();
    }



    private function check_doamin_expire($domain)
    {
        exec(sprintf("/usr/bin/whois %s", $domain), $arr, $retCode);
        if ($retCode == 0)
        {
            $content = join('',$arr);
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

                    if($remain_time < $this->notify_days * 86400)
                    {
                        $this->alert($domain,$days,$exp_date);
                        $this->isAlert = 1;
                        break;
                    }
                }
            }
        }
    }


    private function alert($domain,$days,$exp_date)
    {

        $content = "{$domain}域名还有{$days}天过期\n";
        $content .= "过期时间:{$exp_date}";
        $this->textString['text']['content'] = "{$content}";
        $this->request_by_curl($this->webhook, json_encode($this->textString));
    }






    //钉钉推送消息方法
    private function request_by_curl($remote_server, $post_string)
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



    //curl请求
    private function httpGet($url) {
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


}
