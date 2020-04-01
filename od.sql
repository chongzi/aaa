/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : od

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2020-03-30 23:07:14
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `s_admin`
-- ----------------------------
DROP TABLE IF EXISTS `s_admin`;
CREATE TABLE `s_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT '用户名',
  `nick_name` varchar(50) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL COMMENT '密码',
  `status` int(11) DEFAULT NULL COMMENT '状态：0封号, 1正常',
  `last_login_time` int(11) DEFAULT '0' COMMENT '上次登陆时间',
  `login_time` int(11) DEFAULT '0' COMMENT '本次登陆时间',
  `avatar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='管理员信息表';

-- ----------------------------
-- Records of s_admin
-- ----------------------------
INSERT INTO `s_admin` VALUES ('1', 'admin', '管理员', 'fcea920f7412b5da7be0cf42b8c93759', '1', '0', '0', '');
INSERT INTO `s_admin` VALUES ('2', 'test', 'test', '098f6bcd4621d373cade4e832627b4f6', '1', '0', '0', null);

-- ----------------------------
-- Table structure for `s_auth_group`
-- ----------------------------
DROP TABLE IF EXISTS `s_auth_group`;
CREATE TABLE `s_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组id,自增主键',
  `module` varchar(20) NOT NULL COMMENT '用户组所属模块',
  `type` tinyint(4) NOT NULL COMMENT '组类型',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `description` varchar(80) NOT NULL DEFAULT '' COMMENT '描述信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户组状态：为1正常，为0禁用,-1为删除',
  `rules` varchar(500) NOT NULL DEFAULT '' COMMENT '用户组拥有的规则id，多个规则 , 隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_auth_group
-- ----------------------------
INSERT INTO `s_auth_group` VALUES ('1', 'admin', '1', '默认用户组', '默认用户组', '1', '1,2,3,4,5,6,7,23,24,8,10,11,12,13,14,15,16,20,21,9,17,18,19,22,25,26,27');
INSERT INTO `s_auth_group` VALUES ('2', 'admin', '1', '普通管理员', '', '1', '1,22,26,27');

-- ----------------------------
-- Table structure for `s_auth_group_access`
-- ----------------------------
DROP TABLE IF EXISTS `s_auth_group_access`;
CREATE TABLE `s_auth_group_access` (
  `uid` int(10) unsigned NOT NULL COMMENT '用户id',
  `group_id` mediumint(8) unsigned NOT NULL COMMENT '用户组id',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_auth_group_access
-- ----------------------------
INSERT INTO `s_auth_group_access` VALUES ('1', '1');
INSERT INTO `s_auth_group_access` VALUES ('2', '2');

-- ----------------------------
-- Table structure for `s_auth_rule`
-- ----------------------------
DROP TABLE IF EXISTS `s_auth_rule`;
CREATE TABLE `s_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `module` varchar(20) NOT NULL COMMENT '规则所属module',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1-url;2-主菜单',
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一英文标识',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '规则中文描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `condition` varchar(300) NOT NULL DEFAULT '' COMMENT '规则附加条件',
  PRIMARY KEY (`id`),
  KEY `module` (`module`,`status`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_auth_rule
-- ----------------------------
INSERT INTO `s_auth_rule` VALUES ('1', 'admin', '2', 'admin/manager/index', '系统设置', '1', '');
INSERT INTO `s_auth_rule` VALUES ('2', 'admin', '1', 'admin/Menu/index', '菜单列表', '1', '');
INSERT INTO `s_auth_rule` VALUES ('3', 'admin', '1', 'admin/Menu/create', '添加', '1', '');
INSERT INTO `s_auth_rule` VALUES ('4', 'admin', '1', 'admin/Menu/edit', '编辑', '1', '');
INSERT INTO `s_auth_rule` VALUES ('5', 'admin', '1', 'admin/Menu/save', '保存', '1', '');
INSERT INTO `s_auth_rule` VALUES ('6', 'admin', '1', 'admin/Menu/update', '更新', '1', '');
INSERT INTO `s_auth_rule` VALUES ('7', 'admin', '1', 'admin/Menu/delete', '删除', '1', '');
INSERT INTO `s_auth_rule` VALUES ('8', 'admin', '1', 'admin/Manager/index', '管理员列表', '1', '');
INSERT INTO `s_auth_rule` VALUES ('9', 'admin', '1', 'admin/Group/index', '用户组', '1', '');
INSERT INTO `s_auth_rule` VALUES ('10', 'admin', '1', 'admin/Manager/create', '添加', '1', '');
INSERT INTO `s_auth_rule` VALUES ('11', 'admin', '1', 'admin/Manager/save', '保存', '1', '');
INSERT INTO `s_auth_rule` VALUES ('12', 'admin', '1', 'admin/Manager/edit', '编辑', '1', '');
INSERT INTO `s_auth_rule` VALUES ('13', 'admin', '1', 'admin/Manager/update', '更新', '1', '');
INSERT INTO `s_auth_rule` VALUES ('14', 'admin', '1', 'admin/Manager/delete', '删除', '1', '');
INSERT INTO `s_auth_rule` VALUES ('15', 'admin', '1', 'admin/Manager/forbid', '禁用', '1', '');
INSERT INTO `s_auth_rule` VALUES ('16', 'admin', '1', 'admin/Manager/allow', '启用', '1', '');
INSERT INTO `s_auth_rule` VALUES ('17', 'admin', '1', 'admin/AuthManager/action', '访问授权', '1', '');
INSERT INTO `s_auth_rule` VALUES ('18', 'admin', '1', 'admin/AuthManager/auth', '更新授权', '1', '');
INSERT INTO `s_auth_rule` VALUES ('19', 'admin', '1', 'admin/AuthManager/user', '成员授权', '1', '');
INSERT INTO `s_auth_rule` VALUES ('20', 'admin', '1', 'admin/Manager/group', '所属用户组', '1', '');
INSERT INTO `s_auth_rule` VALUES ('21', 'admin', '1', 'admin/Manager/auth', '角色授权', '1', '');
INSERT INTO `s_auth_rule` VALUES ('22', 'admin', '1', 'admin/Index/profile', '个人资料', '1', '');
INSERT INTO `s_auth_rule` VALUES ('23', 'admin', '1', 'admin/Menu/sort', '排序', '1', '');
INSERT INTO `s_auth_rule` VALUES ('24', 'admin', '1', 'admin/Menu/clear', '清理', '1', '');
INSERT INTO `s_auth_rule` VALUES ('25', 'admin', '2', 'admin/module/index', '模块管理', '1', '');

-- ----------------------------
-- Table structure for `s_domain`
-- ----------------------------
DROP TABLE IF EXISTS `s_domain`;
CREATE TABLE `s_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(50) DEFAULT '' COMMENT '域名表',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='域名表';

-- ----------------------------
-- Records of s_domain
-- ----------------------------
INSERT INTO `s_domain` VALUES ('9', 'd444');
INSERT INTO `s_domain` VALUES ('8', 'sdfd');
INSERT INTO `s_domain` VALUES ('3', 'www.6071.com');
INSERT INTO `s_domain` VALUES ('4', 'www.tuitui99.com');

-- ----------------------------
-- Table structure for `s_menu`
-- ----------------------------
DROP TABLE IF EXISTS `s_menu`;
CREATE TABLE `s_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '标题',
  `pid` int(10) NOT NULL DEFAULT '0' COMMENT '上级分类ID',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序（同级有效）',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `hide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `tip` varchar(255) NOT NULL DEFAULT '' COMMENT '提示',
  `group` varchar(50) DEFAULT '' COMMENT '分组',
  `is_dev` tinyint(1) unsigned DEFAULT '0' COMMENT '是否仅开发者模式可见',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8 COMMENT='后台菜单';

-- ----------------------------
-- Records of s_menu
-- ----------------------------
INSERT INTO `s_menu` VALUES ('1', '系统设置', '0', '99', 'admin/index/profile', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('2', '菜单列表', '1', '2', 'admin/Menu/index', '0', '', '菜单管理', '0');
INSERT INTO `s_menu` VALUES ('4', '添加', '2', '0', 'admin/Menu/create', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('5', '编辑', '2', '0', 'admin/Menu/edit', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('6', '保存', '2', '0', 'admin/Menu/save', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('7', '更新', '2', '0', 'admin/Menu/update', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('8', '删除', '2', '0', 'admin/Menu/delete', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('9', '管理员列表', '1', '0', 'admin/Manager/index', '0', '', '授权管理', '0');
INSERT INTO `s_menu` VALUES ('10', '用户组', '1', '1', 'admin/Group/index', '0', '', '授权管理', '0');
INSERT INTO `s_menu` VALUES ('11', '添加', '9', '0', 'admin/Manager/create', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('12', '保存', '9', '0', 'admin/Manager/save', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('13', '编辑', '9', '0', 'admin/Manager/edit', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('14', '更新', '9', '0', 'admin/Manager/update', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('15', '删除', '9', '0', 'admin/Manager/delete', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('16', '禁用', '9', '0', 'admin/Manager/forbid', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('17', '启用', '9', '0', 'admin/Manager/allow', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('18', '访问授权', '10', '0', 'admin/AuthManager/action', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('19', '更新授权', '10', '0', 'admin/AuthManager/auth', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('20', '成员授权', '10', '0', 'admin/AuthManager/user', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('21', '所属用户组', '9', '0', 'admin/Manager/group', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('22', '角色授权', '9', '0', 'admin/Manager/auth', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('29', '个人资料', '1', '1', 'admin/Index/profile', '0', '', '个人中心', '0');
INSERT INTO `s_menu` VALUES ('31', '排序', '2', '0', 'admin/Menu/sort', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('32', '清理', '2', '0', 'admin/Menu/clear', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('40', '模块管理', '0', '60', 'admin/module/index', '0', '', '模块管理', '1');
INSERT INTO `s_menu` VALUES ('124', '域名管理', '0', '0', 'admin/domain/index', '0', '', '', '0');
INSERT INTO `s_menu` VALUES ('126', '域名列表', '124', '0', 'admin/domain/index', '0', '', '域名管理', '0');
