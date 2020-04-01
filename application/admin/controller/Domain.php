<?php
namespace app\admin\controller;
use think\Controller;
use struct\Tree;



class Domain extends BaseController
{
    function __construct()
    {
        parent::__construct();
    }

    //订单列表
    public function index(){
        $domain = input('get.domain/s');
        $where = [];
        if($domain){
            $where['domain'] = ['like',"%{$domain}%"];
        }
        $page = input("param.p",1);
        $page_size = config('admin_pages_num');
        $count = 0;
        $list = model('domain')->search($where,$order='id desc',$page,$page_size,$count);
        $page_html = get_page_html($count,$page_size);
        $this->data["page_html"] = $page_html;
        $this->data['list'] = $list;
        $this->data["domain"] = $domain;
        return view('index', $this->data);
    }


    public function edit(){
        $id = input('id/d');
        if($id){
            $info = model('domain')->info($id);
            if($info){
                $info['domain_remark'] = $info['domain'].($info['remark'] ? ','.$info['remark'] : '');
            }
            $this->data['info'] = $info;
        }
        $this->data['id'] = $id;
        return view("edit", $this->data);
    }

    //修改状态
    public function updStatus(){
        $id = input('post.id/d');
        $status = input('post.status/d');
        $res = model('domain')->updAttr($id,'status',$status);
        if($res !== false){
            apkReturn([],1, '修改成功');
        }else{
            apkReturn('修改失败', 0);
        }
    }


    public function upd()
    {
        $id = input('post.id/d');
        $domain = input('post.domain/s');

        $domain = trim($domain);

        if(!$domain){
            $this->error('请填写域名');
        }

        if(!$id)
        {
            $domains = explode("\n",$domain);

            foreach($domains as $dm_mark)
            {
                $tmp = explode(',',$dm_mark);
                $dm = $tmp[0];
                $remark = $tmp[1];
                $dm = preg_replace('/[,;\s]/is','',$dm);
                if($dm)
                {
                    $info = model('domain')->infoBy(['domain'=>$dm]);
                    if(!$info)
                    {
                        model('domain')->add(['domain' => $dm, 'remark' => $remark]);
                    }
                }

            }
            $this->success('添加成功','/yc');
        }
        else{
            $tmp = explode(",",$domain);
            $data = [
                'domain' => $tmp[0],
                'remark' => $tmp[1]
            ];

            $res = model('domain')->where('id', $id)->update($data);
            if($res !== false){
                $this->success('更新成功', '/yc');
            }else{
                $this->error('更新失败');
            }
        }
    }


    public function del()
    {
        $id = input('id/a');
        $res = model('domain')->del($id);
        if ($res!==false) {
            apkReturn([],1, '删除成功');
        } else {
            apkReturn('删除失败', 0);
        }
    }


}
