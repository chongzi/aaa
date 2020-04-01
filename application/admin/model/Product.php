<?php
namespace app\admin\model;

use think\Model;
use think\Db;
class Product extends BaseModel
{
    //新增和更新自动完成
    protected $auto = [];
    protected $insert = [];  
    protected $update = [];  

    protected function initialize($model='',$class='')
    {
        $arr = explode("\\", __CLASS__);
        //$model = "admin/".$arr[count($arr)-1];//获取当前模型
        $model = $arr[count($arr)-1];//获取当前模型
        parent::initialize($model,__CLASS__);
    }

    //订单列表
    function getList($search,$page,$page_size,&$count){
        $where = '1';
        if($search['start_date'])$where .= " and add_date>=".intDate($search['start_date']);
        if($search['end_date']) $where .= " and add_date<=".intDate($search['end_date']);
        if($search['vendor']) $where .= " and vendor like '%{$search['vendor']}%'";
        if($search['product_name']) $where .= " and product_name like '%{$search['product_name']}%'";
        $offset = ($page-1)*$page_size;
        $sql = "
            select * from s_product where {$where} order by id desc limit {$offset},{$page_size}
        ";

        $sql_count = "
            select count(1) as num from s_product where {$where}
        ";
        // echo '<pre>'.$sql;
        $list =  Db::query($sql);
        $count = Db::query($sql_count);
        $count = $count[0]['num'];
        return $list;
    }




}