<?php if (!defined('THINK_PATH')) exit(); /*a:9:{s:82:"D:\phpstudy\PHPTutorial\WWW\od\public/../application/admin\view\index\profile.html";i:1573709578;s:72:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\layout\common.html";i:1527670686;s:78:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\htmlheader.html";i:1582906808;s:85:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\common_components.html";i:1527670686;s:78:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\mainheader.html";i:1576137816;s:75:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\sidebar.html";i:1527670686;s:81:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\contentheader.html";i:1527670686;s:74:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\footer.html";i:1527670686;s:75:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\scripts.html";i:1527670686;}*/ ?>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <title> <?php echo (isset($app_name) && ($app_name !== '')?$app_name:'admin'); ?> </title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.7 -->
    <link rel="stylesheet" href="/static/bower_components/bootstrap/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="/static/bower_components/font-awesome/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="/static/bower_components/Ionicons/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="/static/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="/static/dist/css/skins/_all-skins.min.css">

    <link rel="stylesheet" href="/admin/css/base.css">
    <script src="/static/bower_components/jquery/dist/jquery.min.js"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="/static/bower_components/jquery-ui/jquery-ui.min.js"></script>
    <script src="/admin/js/base.js"></script>
    <script src="/admin/js/main.js"></script>
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <link rel="stylesheet" href="/static/bower_components/bootstrap-fileinput/css/fileinput.min.css">
    <link rel="stylesheet" href="/static/bower_components/select2/dist/css/select2.min.css">
    <script src="/static/bower_components/bootstrap-fileinput/js/fileinput.min.js"></script>
    <script src="/static/bower_components/bootstrap-fileinput/js/locales/zh.js"></script>
    <link href="<?php echo \think\Config::get('__PUBLIC__'); ?>static/datetimepicker/css/datetimepicker.css" rel="stylesheet" type="text/css">
    <link href="<?php echo \think\Config::get('__PUBLIC__'); ?>static/datetimepicker/css/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<?php echo \think\Config::get('__PUBLIC__'); ?>static/datetimepicker/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="<?php echo \think\Config::get('__PUBLIC__'); ?>static/datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<?php echo \think\Config::get('__PUBLIC__'); ?>static/datetimepicker/js/quickdateselect.js"></script>
    <script type="text/javascript" src="<?php echo \think\Config::get('__PUBLIC__'); ?>static/js/selectSearchAdmin.js" charset="UTF-8"></script>
    <script type="text/javascript" src="/static/layer/layer.js"></script><!-- 弹窗js 参考文档 http://layer.layui.com/-->
    <script src="/static/bower_components/select2/dist/js/select2.min.js"></script>
    <link href="<?php echo \think\Config::get('__PUBLIC__'); ?>static/layui/css/layui.css" rel="stylesheet" type="text/css">
    <script src="<?php echo \think\Config::get('__PUBLIC__'); ?>static/layui/layui.js" charset="utf-8"></script> 
    
</head>

<body class="skin-blue sidebar-mini">
<div class="wrapper">
    <div id="alert" class="main-alert alert alert-dismissible alert-danger">
    <button type="button" class="close" click="alertClose">×</button>
    <h4><i class="icon fa fa-warning"></i><span></span></h4>
</div>

<div class="modal modal-default fade" id="modal-panel">
    <div class="modal-dialog">
        <div class="panel panel-default">
            <div class="panel-heading" data-dismiss="modal">消息</div>
            <div class="panel-body text-center">
            </div>
        </div>
    </div>
</div>

<div class="modal modal-default fade" id="modal-confirm">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">确认执行该操作？</h4>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left reject" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger resolve" data-dismiss="modal">确认</button>
            </div>
        </div>
    </div>
</div>

<div class="modal modal-default fade" id="modal-prompt">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">确认执行该操作？</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                  <input type="text" name="prompt" class="form-control">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left reject" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger resolve" data-dismiss="modal">确认</button>
            </div>
        </div>
    </div>
</div>



    <!-- Main Header -->
<header class="main-header">

    <!-- Logo -->
    <a href="/yc.html" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini"><b><?php echo (isset($app_name) && ($app_name !== '')?$app_name:'A'); ?></b></span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg"><b><?php echo (isset($app_name) && ($app_name !== '')?$app_name:'Admin'); ?></b> </span>
    </a>

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
        <!-- Sidebar toggle button-->
        <div class="container-fluid">
            <div class="navbar-header">
                <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                    <span class="sr-only">Toggle navigation</span>
                </a>
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
                <i class="fa fa-bars"></i>
                </button>
        </div>

        <div class="collapse navbar-collapse" id="navbar-collapse">
            <ul class="nav navbar-nav">
            <?php if(is_array($nav) || $nav instanceof \think\Collection || $nav instanceof \think\Paginator): $i = 0; $__LIST__ = $nav;if( count($__LIST__)==0 ) : echo "" ;else: foreach($__LIST__ as $key=>$menu): $mod = ($i % 2 );++$i;?>
                <li class="<?php echo $menu->current()?'active' : ''; ?>"><a href="<?php echo url($menu->url); ?>"><?php echo $menu['title']; ?></a></li>
            <?php endforeach; endif; else: echo "" ;endif; ?>
            </ul>

            <!-- Navbar Right Menu -->
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <img src="<?php echo $admin->avatar(); ?>" class="user-image" alt="User Image">
                            <span class="hidden-xs"><?php echo $admin['nick_name']; ?></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="user-header">
                                <img src="<?php echo $admin->avatar(); ?>" class="img-circle" alt="User Image">

                                <p>
                                    你好，<?php echo $admin['nick_name']; ?>！
                                </p>
                            </li>

                            <li class="user-footer">
                                <!-- <div class="pull-left">
                                    <a href='<?php echo url("admin/profile"); ?>' class="btn btn-default btn-flat">编辑资料</a>
                                </div> -->
                                <div class="pull-right">
                                    <a href='<?php echo url("pub/logout"); ?>' class="btn btn-default btn-flat">退出</a>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>
 

    <!-- Left side column. contains the logo and sidebar -->
<aside class="main-sidebar">

    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">

      <!-- Sidebar user panel -->
      <div class="user-panel">
        <div class="pull-left image">
          <img src="<?php echo $admin->avatar(); ?>" class="img-circle" alt="User Image">
        </div>
        <div class="pull-left info">
          <p><?php echo $admin['nick_name']; ?></p>
          <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
        </div>
      </div>

      <ul class="sidebar-menu" data-widget="tree">
        <?php if(is_array($sideMenus) || $sideMenus instanceof \think\Collection || $sideMenus instanceof \think\Paginator): $groupName = 0; $__LIST__ = $sideMenus;if( count($__LIST__)==0 ) : echo "" ;else: foreach($__LIST__ as $key=>$group): $mod = ($groupName % 2 );++$groupName;?>
        <li class="treeview <?php echo !empty($group['current'])?'active' : ''; ?>">
          <a href="#">
            <i class="fa fa-folder"></i> <span><?php echo $key; ?></span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <?php if(is_array($group) || $group instanceof \think\Collection || $group instanceof \think\Paginator): $i = 0; $__LIST__ = $group;if( count($__LIST__)==0 ) : echo "" ;else: foreach($__LIST__ as $key=>$menu): $mod = ($i % 2 );++$i;if(is_object($menu)): ?>
            <li class="<?php echo $menu->current()?'active' : ''; ?>"><a href="<?php echo url($menu->url); ?>">&nbsp;&nbsp;&nbsp;&nbsp;<i class="fa fa-file"></i><?php echo $menu['title']; ?></a></li>
            <?php endif; endforeach; endif; else: echo "" ;endif; ?>
          </ul>
        </li>
        <?php endforeach; endif; else: echo "" ;endif; ?>

      </ul>

    </section>
    <!-- /.sidebar -->
</aside>
 

    <div class="content-wrapper">

        <!-- Content Header (Page header) -->
<section class="content-header">
    <!-- <h1>
        home
        <small>info of home.</small>
    </h1>

    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Dashboard</li>
    </ol> -->
</section>


        <section class="content">
            
<div class="row">

    <div class="col-md-12">
        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title">更新资料</h3>
            </div>
            
            <form action="<?php echo url('admin/index/update'); ?>" method="POST" class="form-horizontal ajax-post">
                <div class="box-body">
                    
                    <div class="form-group">
                        <label for="password" class="col-sm-2 control-label">原始密码 *</label>

                        <div class="col-sm-10">
                            <input type="password" name="password" class="form-control" id="password">
                            <span class="help-block"><b>必须填写，用于验证</b></span>
                        </div>
                    </div>
                    <hr>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">上传头像</label>

                        <div class="col-sm-10">
                            <input type="hidden" class="file-upload" name="avatar" value="<?php echo $admin['avatar']; ?>">
                            <img src="<?php echo $admin->avatar(); ?>" height="100" class="image-upload" data-field-name="avatar">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">用户名</label>

                        <div class="col-sm-10">
                            <input type="text" disabled class="form-control" value="<?php echo $admin['name']; ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="nick_name" class="col-sm-2 control-label">昵称</label>

                        <div class="col-sm-10">
                            <input type="text" name="nick_name" class="form-control" id="nick_name" value="<?php echo $admin['nick_name']; ?>">
                            <span class="help-block">不超过25个字符</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="new_password" class="col-sm-2 control-label">新密码</label>

                        <div class="col-sm-10">
                            <input type="password" name="new_password" class="form-control" id="new_password">
                            <span class="help-block">6~25个字符</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="re_password" class="col-sm-2 control-label">重复密码</label>

                        <div class="col-sm-10">
                            <input type="password" name="re_password" class="form-control" id="re_password">
                        </div>
                    </div>
                </div>
                
                <div class="box-footer">
                    <button type="submit" class="btn btn-default back">返回</button>
                    <button type="submit" class="btn btn-success">更新</button>
                </div>
            </form>
        </div>
    </div>
</div>

        </section>
    </div>

    

</div>
<!-- REQUIRED JS SCRIPTS -->

<!-- JQuery and bootstrap are required by Laravel 5.3 in resources/assets/js/bootstrap.js-->
<!-- Laravel App -->

<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>
  $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.7 -->
<script src="/static/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- Morris.js charts -->
<script src="/static/bower_components/raphael/raphael.min.js"></script>
<script src="/static/bower_components/morris.js/morris.min.js"></script>
<!-- Sparkline -->
<script src="/static/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js"></script>
<!-- jvectormap -->
<script src="/static/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
<script src="/static/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
<!-- jQuery Knob Chart -->
<script src="/static/bower_components/jquery-knob/dist/jquery.knob.min.js"></script>
<!-- daterangepicker -->
<script src="/static/bower_components/moment/min/moment.min.js"></script>
<script src="/static/bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
<!-- datepicker -->
<script src="/static/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<!-- Bootstrap WYSIHTML5 -->
<script src="/static/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
<!-- Slimscroll -->
<script src="/static/bower_components/jquery-slimscroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/static/bower_components/fastclick/lib/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="/static/dist/js/adminlte.min.js"></script>



</body>
</html>
