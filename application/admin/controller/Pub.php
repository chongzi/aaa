<?php

namespace app\admin\controller;

use app\admin\logic\Authentication;
use think\Controller;
use think\Request;

class Pub extends Controller
{
    protected $request;

    public function __construct()
    {
        $this->request = Request::instance();
    }

    public function index()
    {
        if (Authentication::checkLogin()) {
            return $this->redirect('/yc.html');
        }
        else
        {
            return $this->redirect(url('login'));
        }
    }

    public function login()
    {
        if (Authentication::checkLogin()) {
            return $this->redirect('/yc.html');
        }

        $name = $this->request->post('name');
        $password = $this->request->post('password') ;
        if($name && $password)
        {
            $res = Authentication::login($name, $password);
            if ($res === 0) {
                return $this->error('用户名或密码错误');
            } 
            elseif ($res === -1) {
                return $this->error('用户不存在或被禁用');
            } 
            else {
                return $this->success('登录成功','/yc.html');
            }
        }
        else
        {
            return view('login');
        }
    }

    public function logout()
    {
        Authentication::logout();
        $this->redirect(url('login'));
    }
}
