var express = require('express');
var router = express.Router();
var child_process = require('child_process');
var path =require('path');
var readline = require('readline');
var fs = require('fs');
//var sleep = require('sleep');

/* GET home page. */
router.get('/', function(req, res, next) {

  //下载init.sh文件 并修改权限
  child_process.exec('wget https://raw.githubusercontent.com/humstarman/ikube/master/init.sh && chmod 777 init.sh',function(err,stdout,stderr){
    if(err){
      console.log(err);
    }else if(stderr){
      console.log(stderr);
    }else if(stdout){
      console.log(stdout);
    }else{
      console.log('other...');
    }
  });


  //渲染安装页面
  res.render('install');

});

router.post('/',function(req,res){
  
  //获取参数值i

  var masterNode = req.body['master_node'];
  var sshPwd = req.body['ssh_pwd'];
  var nodeNode = req.body['node_node'];
  var virtualIP = req.body['virtual_ip'];
  var haStrategy = req.body['ha_strategy'];
  var cniStrategy = req.body['cni_strategy'];
  var profixStrategy = req.body['profix_strategy'];
  var kubernetVersion = req.body['version'];

  //定义参数

  var M = '-m';
  var N = '-n';
  var P = '-p';
  var A = '-a';
  var V = '-v';
  var C = '-c';
  var X = '-x';
  var K = '-k';


  if(nodeNode == ""){
    N = "";
  }

  if(virtualIP == ""){
    V = "";
  }

  //测试
  console.log('=================================');

  console.log('master:'+masterNode);
  console.log('SSH:'+sshPwd);
  console.log('node:'+nodeNode);
  console.log('virtual ip:'+virtualIP);
  console.log('HA:'+haStrategy);
  console.log('ser:'+profixStrategy);
  console.log('CNI:'+cniStrategy);
  console.log('Kuber:'+kubernetVersion);

  console.log('=================================');
 
  //var obj = new Object(); 
  var args =[M,masterNode,N,nodeNode,P,sshPwd,A,haStrategy,V,virtualIP,C,cniStrategy,X,profixStrategy,K,kubernetVersion];
// var execPath = path.resolve(__dirname,'./init.sh');
 // console.log(__dirname);
 // for(var x in args){
 // obj[x] = x;
 // }
 //

/* child_process.exec('sed -i s?"bin/bash"?"usr/bin/env node"?g init.sh',function(err,stdout,stderr){
  if(err){
    console.log('in err...');
    console.log(err);
  }else if(stdout){
    console.log('in stdout。。。');
    console.log(stdout);
  }else if(stderr){
    console.log('in stderr');
    console.log(stderr);
  }else{
    console.log('in others...');
  }
 }); */
 
//child_process.execFile('/root/kuweb-master/init.sh',[M,masterNode,N,nodeNode,P,sshPwd,A,haStrategy,V,virtualIP,C,cniStrategy,X,profixStrategy,K,kubernetVersion],function(err,stdout,stderr){
 child_process.exec('./init.sh'+' '+M+' '+masterNode+' '+N+' '+nodeNode+' '+P+' '+sshPwd+' '+A+' '+haStrategy+' '+V+' '+virtualIP+' '+C+' '+
             cniStrategy+' '+X+' '+profixStrategy+' '+K+' '+kubernetVersion+' > /tmp/install.log',function(err,stdout,stderr){ 
//child_process.execFile('./init.sh',args,null,function(err,stdout,stderr){  
//
  // console.log(process.env.PATH);
   //打印子进程当前的工作目录/root/kuweb-master
   //console.log(process.cwd());
   if(err){
      console.log('in err');
      console.log(err);
    }else if(stdout){
      console.log('in stdout');
      console.log(stdout);
    }else if(stderr){
      console.log('in stderr');
      console.log(stderr);
    }
   });

   //把日志文件按行读取，但是并没有按行显示在页面上
/*    res.writeHead(200,{'Content-type':'text/html;chartset=utf8'});
   
   var r1 = readline.createInterface({
     input:fs.createReadStream("/tmp/install.log")
  });

  var i =1 ;

  r1.on('line',(line)=>{
    res.write('Line from file:'+i+":"+line+'<br/>');
      
//    sleep.sleep(5);

    i += 1;
  });*/
   
  res.render('afterinstall');

  
});


module.exports = router;
