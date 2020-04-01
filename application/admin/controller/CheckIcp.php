<?php
namespace app\admin\controller;
use think\Controller;
use struct\Tree;
use think\Cache;

//备案号每小时检测一次
class CheckIcp extends Controller
{

    private $webhook = "https://oapi.dingtalk.com/robot/send?access_token=8fcef16a74469670df6e17361171a631ec8326590d403ecafe13dc7e84ee45d2";
    private $textString = [];
    private $isAlert = 0; // 0正常  1报警


    function __construct()
    {
        set_time_limit(3500);
        header("Content-type:text/html;charset=utf-8");
        if ( strpos($_SERVER['HTTP_USER_AGENT'], 'yangcheng') === false ) {

         //   die('非法访问');

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


    //检测备案号
    public function icp(){
        $t1 = time();
        $logPath = LOG_PATH.'icp_'.date('Ymd').'.log';
        $logStr = '------------------------------'."\r\n".date('Y-m-d H:i:s')."\r\n";
        $logStr .= '已检测域名:'."\t";

        while(1){
            $min_id = Cache::get('icp_min_id');
            $min_id = $min_id ? $min_id : 0;
            $where['id'] = array('gt',$min_id);
            $where['status'] = 0;
            $domain_list = model('domain')->listBy($where,$field='*',$limit=1000,$order='id asc');

            if($domain_list)
            {
                foreach($domain_list as $row)
                {
                    $domain = $row['domain'];
                    $url = "https://api.ooopn.com/icp/api.php?url={$domain}";
                    $res = $this->httpGet($url);
                    $res = json_decode($res,1);
                    if($res['code'] != 200)
                    {
                        $content = $res['msg'];
                        $this->textString['text']['content'] = "{$domain}---{$content}";
                        $this->request_by_curl($this->webhook, json_encode($this->textString));
                        $this->isAlert = 1;
                    }

                    Cache::set('icp_min_id',$row['id']);
                    $logStr .= " {$domain} |";
                }
            }
            else{
                $t2 = time();
                $logStr .=  "\r\n运行时间:". ($t2 - $t1) . "s\r\n";
                error_log($logStr,3,$logPath);
                Cache::set('icp_min_id',null); //重置

                //正常则2小时告知一次正常运行 0-8点不提醒
                if($this->isAlert == 0)
                {
                    $hour = (int)date('H');
                    if($hour>=8 && $hour%2==0)
                    {
                        $this->textString['text']['content'] = "域名备案监测正常";
                        $this->request_by_curl($this->webhook, json_encode($this->textString));
                    }
                }
                exit();
            }
        }




        exit();

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
