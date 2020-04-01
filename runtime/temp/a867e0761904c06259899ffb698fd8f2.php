<?php if (!defined('THINK_PATH')) exit(); /*a:8:{s:81:"D:\phpstudy\PHPTutorial\WWW\od\public/../application/admin\view\domain\index.html";i:1585705175;s:72:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\layout\common.html";i:1527670686;s:78:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\htmlheader.html";i:1582906808;s:85:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\common_components.html";i:1527670686;s:78:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\mainheader.html";i:1576137816;s:75:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\sidebar.html";i:1527670686;s:74:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\footer.html";i:1527670686;s:75:"D:\phpstudy\PHPTutorial\WWW\od\application\admin\view\partials\scripts.html";i:1527670686;}*/ ?>
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

        

<section class="content-header">
    <h1>
        域名列表
    </h1>
</section>


        <section class="content">
            
<div class="row">
    <div class="col-xs-12">

        <div class="box box-success">
            <div class="box-header">
                <a href="<?php echo url('Domain/edit'); ?>" type="button" class="btn btn-success btn-sm">添加<i class="fa fa-fw fa-plus"></i></a>
                <p><p/>
                <form method="get" action="<?php echo url('/yc'); ?>" id="search" class="form-inline">
                    <input  type="text" name="domain" value="<?php echo $domain; ?>" placeholder="请输入域名" class="form-control"/>
                    <a class="btn btn-success btn-sm"  href="javascript:$('#search').submit();">搜  索</a>
                </form>
            </div>
            <form method="POST" id="form_list" name="form_list">
                <div class="box-body">
                    <table class="table table-hover table-bordered">
                        <tr>
                            <th><input id="all"   type="checkbox"  onclick="chk_all()" /></th>
                            <th class="">ID</th>
                            <th class="">域名</th>
                            <th class="">备注</th>
                            <th class="">备案</th>
                            <th class="">操作</th>
                        </tr>
                        <?php if(is_array($list) || $list instanceof \think\Collection || $list instanceof \think\Paginator): $i = 0; $__LIST__ = $list;if( count($__LIST__)==0 ) : echo "" ;else: foreach($__LIST__ as $key=>$vo): $mod = ($i % 2 );++$i;?>
                        <tr>
                            <td>
                                <input class="check-all" type="checkbox" value="<?php echo $vo['id']; ?>" name="id[]" />
                            </td>
                            <td>
                                <?php echo $vo['id']; ?>
                            </td>
                            <td>
                                <?php echo $vo['domain']; ?>
                            </td>
                            <td>
                                <?php echo $vo['remark']; ?>
                            </td>
                            <td>
                                <?php if($vo['status'] == 0): ?>
                                    <a type="button" class="btn btn-success btn-sm" onclick="plan.updStatus($(this),<?php echo $vo['id']; ?>,1)">开启</a>
                                <?php else: ?>
                                    <a type="button" class="btn btn-default btn-sm" onclick="plan.updStatus($(this),<?php echo $vo['id']; ?>,0)">关闭</a>
                                <?php endif; ?>
                            </td>
                            <td>
                                <a href="<?php echo url('edit?id='.$vo['id']); ?>">编辑</a>&nbsp;|
                                <a title="删除" href="javascript:;" onclick="plan.del(<?php echo $vo['id']; ?>);">删除</a>
                            </td>
                        </tr>
                        <?php endforeach; endif; else: echo "" ;endif; ?>
                    </table>
                    <div class="h_pagination" style="padding-top: 15px;">
                        <?php echo $page_html; ?>
                    </div>
                </div>
                <div class="box-header" style="padding-bottom:20px;">
                    <a class="btn btn-success btn-sm" onclick="plan.del('pi',0);">删除</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    var plan = {
        init:function () {
            $('#app_id').select2();
        },

        updStatus:function(o,id,status){
            $.post("<?php echo url('admin/domain/updStatus'); ?>",{id:id,status:status},function (data) {
                layer.closeAll();
                if(data.code==1){
                    layer.msg(data.msg, {icon: 1, time: 2000},function(){
                        window.location.reload();
                    });
                }else{
                    layer.msg(data.msg, {icon: 2,time: 2000});
                }
            },'json');
        },
        // 删除/恢复
        del: function(ids,is_del){
            if(typeof ids == 'undefined' || ids === 'pi'){
                var ids = [];
                $("input[name='id[]']:checked").each(function(){
                    ids.push($(this).val());
                });

                if(ids.length==0){
                    layer.msg('请勾选需要操作的数据', {icon: 2,time: 2000});
                    return;
                }
            }
            layer.confirm('确定执行删除操作？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                $.post("<?php echo url('admin/domain/del'); ?>",{'id':ids},function (data) {
                    layer.closeAll();
                    if(data.code==1){
                        layer.msg(data.msg, {icon: 1, time: 2000},function(){
                            window.location.reload();
                        });
                    }else{
                        layer.msg(data.msg, {icon: 2,time: 2000});
                    }
                },'json');

            });
        }
    };

    plan.init();




</script>

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
