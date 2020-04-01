<?php

namespace app\admin\controller;
use think\Controller;
//公共控制器
class Common extends BaseController
{
    //上传图片
    public function upload()
    {
        $f = request()->file();
        $pics = model('BaseModel')->upload(key($f));
        $pic = $pics[0]['path'];
        apkReturn($pic);
    }
}
