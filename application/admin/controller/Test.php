<?php
namespace app\admin\controller;
use think\Controller;
use think\Db;

class Test extends Controller
{
    function __construct()
    {
        parent::__construct();
    }

    public function index()
    {
        $info = [
            'id' => 6,
            'app_id' => 17,
            'ad_id' => 5,
            'income' => 1000.00,
            'add_date' => 20200101,
            'upd_date' => 20200103,
        ];
        $res = model('AdIncomeSet')->upd($info);

        dump($res);die;
    }

    public function updTodayData(){
         Db::execute("call ad_income(1)");
         die('ok');
    }

    public function updTodayData2(){
        Db::execute("call tg_count_day(1)");
        die('ok');
    }
}
