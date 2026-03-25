// 本文件包含：
//  1. 字体配置; 
//  2. 论文基本信息配置 (如姓名、题目等); 
//  3. 论文正文外的内容 (如摘要、附录、简历等)

// ==================================
//
//         Step 1. 定义字体组合
//
// ==================================
// 先在这里定义字体组合，再在Step 2中选择想要使用的字体组合

#let Win版字体 =  ( 
  仿宋: ("Times New Roman",  "FangSong"), // "FangSong_GB2312"
  宋体: ("Times New Roman",  "SimSun"), // "NSimSun"
  黑体: ("Arial",            "SimHei"),
  楷体: ("Times New Roman",  "KaiTi"), // "KaiTi_GB2312"
  代码: ("DejaVu Sans Mono", "SimHei"),
)
// 对于每类字体，应先定义西文字体，再定义中文字体。例如：黑体对应的西文字体设置为Arial，中文字体设置为SimHei。
// 不同系统、不同版本的“宋黑仿楷”中文字体在调用时的名称可能不同，可能需要自行查证并修改。
// 《指南》未对代码字体作强制要求，此处选用DejaVu Sans Mono，该字体适用于Typst Web App和多数Linux发行版。而在其他本地环境下，Windows系统可改为Consolas，macOS可改为Menlo

#let 开源字体 = (
  仿宋: ("Tex Gyre Termes", "FandolFang R", "Noto Serif CJK SC"),
  宋体: ("Tex Gyre Termes", "FandolSong", "Noto Serif CJK SC"), // Fandol宋体基线偏低，谨慎使用
  黑体: ("Tex Gyre Heros","FandolHei", "Noto Sans CJK SC"),
  楷体: ("Tex Gyre Termes", "FandolKai", "Noto Serif CJK SC"),
  代码: ("DejaVu Sans Mono", "Noto Sans CJK SC"),
) 




// ==================================
//
//         Step 2. 基本信息配置
//
// ==================================

#let settings = (

字体: Win版字体, 
// 填写上方的定义的字体组合名称，如"Win版字体"或"开源字体"。
//【强烈建议】选择Win版，字体文件需自行获取并上传到Web APP目录（如果是本地使用，请安装到本机）。
// 请确保正确配置，直到消除所有“unknown font family”错误提示。

文章类型: "Thesis", //"Thesis"或"Dissertation"

作者名: "作者名",

作者_英: "Author Name",

论文题目:[
  
  清华大学研究生学位论文
  
  Typst模板 v0.5.1
  
], // 如果想要手动换行，需要插入额外的空行，如此处所示

论文题目_英: "T4: Tsinghua Thesis Typst Template",

副标题: "申请清华大学医学博士学位论文",

院系: "基础医学系",

英文学位名: "Doctor of Medicine",

专业: "基础医学",

专业_英: "Basic Medical Sciences",

导师: "导师名 教授",

导师_英: "Professor Sprvsr Name",

副导师: "副  导 教授", //没有填none

副导师_英: "Professor AssocSprvsr Name", //没有填none

//日期: datetime(year: 1911, month: 4, day: 26), //默认为当前日期

参考文献格式: "cell", 
// 推荐多数专业使用"gb-7714-2015-numeric", 生医药专业使用"cell"。其他格式双语支持尚不完善
// 官方文档：https://typst.app/docs/reference/model/bibliography/#parameters-style

文献库: "文献库.bib",

目录深度: 3,

插图清单: true,

附表清单: true,

代码清单: false,

盲审版本: false,

另页右页: true, //正文部分从另页右页开始

)



// ==================================
//
//   Step 3. 填写论文正文以外的其他内容
//
// ==================================

#let 系统性创新性 = none
/*
  博士生对本论文系统性和创新性的总结。模板如下：
  [
    #par(first-line-indent: 0pt)[*1.~~~~对学位论文工作系统性的总结*]
  
    本文XXXXXXXXXXXX
  
    #par(first-line-indent: 0pt)[*2.~~~~对学位论文工作创新性的总结*]
    
    本文XXXXXXXXXXXX
    
  ]
*/

#let 授权 = [
  
  本人完全了解清华大学有关保留、使用学位论文的规定，即：

  清华大学拥有在著作权法规定范围内学位论文的使用权，其中包括：（1）已获学位的研究生必须按学校规定提交学位论文，学校可以采用影印、缩印或其他复制手段保存研究生上交的学位论文；（2）为教学和科研目的，学校可以将公开的学位论文作为资料在图书馆、资料室等场所供校内师生阅读，或在校园网上供校内师生浏览部分内容；（3）根据《中华人民共和国学位法》及上级教育主管部门具体要求，向国家图书馆报送相应的学位论文。
  
  本人保证遵守上述规定。
  
]

#let 指导小组名单 = (
  "某某某",    "教授",    "清华大学",
  "某    某",  "副教授",  "清华大学",
  "某某某",    "助理教授", "清华大学",
)//三个为一组，姓名-职称-单位。如果没有则填none。

#let 公开评阅人名单 = (
  "某某某", "教授",    "清华大学",
  "某某某", "副教授",  "XXXX大学",
  "某某某", "研究员",  "中国XXXX科学院XXXXXX研究所",
)//三个为一组，姓名-职称-单位。若为“无（全隐名评阅）”则填none。

#let 答辩委员会名单 = (
  "主席",  "某某某", "教授",      "清华大学",
  "委员",  "某某某", "教授",      "清华大学",
  "",     "某某某", "研究员",    "中国XXXX科学院\nXXXXXX研究所",
  "",     "某某某", "教授",      "XXXX大学",
  "",     "某某某", "副教授",    "XXXX大学",
  "秘书",  "某某某", "助理研究员", "清华大学",
)//注意，所有委员只有第一个需要写明，其余留空字符串



#let 摘要 = [
  
  本项目是清华大学研究生学位论文*Typst模板*，旨在规定论文各部分内容格式与样式，面向初学者详细介绍模板的使用方法，帮助研究生进行学位论文写作，降低编辑论文格式的不规范性和额外工作量。请注意，这是一个*非官方*的模板，请在使用前充分确认该模板符合院系要求。

  除常见自动排版功能外，本模板的特色功能包括:
  - `#tupian()`函数可以便捷地添加图片、图题、图注等，并防止跨页；
  - `#biaoge()`函数可以便捷地添加三线表并在跨页时自动生成续表题；
  - `#daima()`函数可以添加简单的代码块，并自动编号。
  
  如果有进阶的排版需求，请了解基于LaTeX的ThuThesis模板，这是一个非常成熟的模板，全面支持最新的本科、研究生、博士后论文/报告格式，获研究生院官方推荐。

  本项目受PKUTHSS-Typst和ThuThesis启发，并在PKUTHSS-Typst的基础上修改而来，格式大量参考了ThuWordThesis模板进行像素级对齐。项目使用了以下Typst包：`tablem`、`cuti`、`a2c-nums`、`modern-nju-thesis`。感谢开发者们的贡献。

  #linebreak()
  参考项目链接：
  - 清华大学研究生学位论文写作指南: https://info2021.tsinghua.edu.cn/f/info/xxfb_fg/xnzx/template/detail?xxid=fa880bdf60102a29fbe3c31f36b76c7e
  - PKUTHSS-Typst: https://github.com/pku-typst/pkuthss-typst
  - ThuWordThesis: https://github.com/fatalerror-i/ThuWordThesis
  - ThuThesis(LaTeX): https://github.com/pku-typst/pkuthss-typst
  
]

#let 关键词 = ("Typst", "模板")





#let 摘要_英 = [
  
    This article creates a Tsinghua University graduate dissertation Typst template, which stipulates formats and styles of each section and details usage and creation of template, with the purpose of supporting graduate students writing dissertation, reducing non-standardization and additional workload in editing thesis format.

]

#let 关键词_英 = ("Typst", "Template", [_Italic Text_])



#let 符号和缩略语 = [
  
  / _T4_: 清华大学学位论文typst模板（Tsinghua Thesis Typst Template）
  / pt: 磅值、点数（point）
  / $planck$ : 约化普朗克常数
  / CRISPR/Cas9: 成簇的带有规律间隔序列的短回文重复序列（Clustered Regularly Interspaced Short Palindromic Repeats）和CRISPR相关蛋白9（CRISPR-associated protein 9）

]



#let 附录 = [

= 更新日志 <更新日志>

  == 版本v0.1.0 
  
  - Tsinghua Thesis Typst Template 上线了 

  == 版本v0.2.0

  - 优化了项目结构，以符合Typst Universe的提交要求
  - 将字体替换为开源字体

  == 版本v0.2.1
  - 优化了字体配置提示
  - 设置了个人成果页面的列表样式

  == 版本v0.3.0
  - 新增了博资考模板
  - 修复了封面日期数字十一月/十二月显示有误的bug
  - 改进了图片legend的对齐方式

  == 版本v0.3.1
  - 添加了统一设置特殊名词格式设置的教程
  - 修复了博资考模板正文前页码的bug
  - 修复了正文以外中文*伪粗体*无法显示的bug

  == 版本v0.4.0
  - 添加预览了不正确的文件时的提示
  - 再次优化了字体配置方法
  - 优化了文件结构
  - 为正文格式添加了两端对齐
  - 将授权和声明页内容移至`设置与其他.typ`以便调整，并将内容更新至2025年3月版本
  - 更改了引用节的显示格式（节1.1.1 #sym.arrow 第1.1.1节）

  == 版本v0.4.1
  - 完善了“学位论文指导小组、公开评阅人和答辩委员会名单”页面的所有形式

  == 版本v0.5.0
  - [Breaking] 参考文献支持双语（Powered by `modern-nju-thesis`）
  - 增加了“盲审版本”选项：隐去院系专业、作者及导师姓名、致谢、声明、个人简历、评语决议书等
  - 用于书脊的论文题目现自动根据论文题目生成，无需手动输入
  - 完善了对表达式和代码块的支持
  - 优化了`设置与其他.typ`的结构
  - 支持“另页右页”：开启后正文第一章在奇数页起始
  - 添加了“系统性与创新性”页面与“其他材料”页面（可选）

  == 版本 v0.5.1
  - 优化了项目结构
  - [Breaking] 改进了`#tupian()`、`#biaoge()`和`#daima()`

= 尚不完善的功能

  - 参考文献缩进量由CSL定义，暂无法手动调整。
  注：《指南》要求悬挂缩进2个汉字符或1个厘米，在毕业论文写作中，引用文献通常超过100篇，此时缩进量可以符合《指南》要求。
  - 待补充...

  
]


#let 致谢 = [
  
  致谢正文
  
]

#let 声明 = [
  本人郑重声明：所呈交的学位论文，是本人在导师指导下，独立进行研究工作所取得的成果，不包含涉及国家秘密的内容。尽我所知，除文中已经注明引用的内容外，本学位论文的研究成果不包含任何他人享有著作权的内容。对本论文所涉及的研究工作做出贡献的其他个人和集体，均已在文中以明确方式标明。
]



#let 简历和成果 = [
  == 个人简历

  20XX年XX月XX日出生于XX省XX市。
  
  20XX年XX月考入XX大学XX系XX专业，20XX年XX月本科毕业并获得XX学士学位。
  
  20XX年XX月免试进入清华大学XX系攻读XXXX至今。
  
  
  == 在学期间完成的相关学术成果
  
  === 学术论文:

  9. 论文9
  10. 论文10
  
  === 专利:
  + 专利1
  + 专利2
  
]



#let 指导教师评语 = [
  将指导教师（小组）的评语内容誊录于此，指导教师（指导小组成员）无需签名。指导教师评语的内容与学位（毕业）审批材料一致。保持内容一致是论文作者的学术责任，因内容不一致产生的后果由论文作者承担。
]



#let 答辩委员会决议书 = [
  将答辩委员会决议书内容誊录于此，答辩委员会主席、委员和秘书无需签名。答辩委员会决议书内容与学位（毕业）审批材料一致。保持内容一致是论文作者的学术责任，因内容不一致产生的后果由论文作者承担。
]



#let 其他材料 = none //根据学位评定分委会与院系要求添加





























// ==================================
//
//          以下内容请不要编辑
// 
// ==================================

//盲审版本过滤个人信息
#if (settings.盲审版本){
  settings.作者名 = ""
  settings.作者_英 = ""
  settings.院系 = ""
  settings.专业 = ""
  settings.导师 = ""
  settings.导师_英 = ""
  if settings.副导师 != none { settings.副导师 = "" }
  if settings.副导师_英 != none { settings.副导师_英 = "" }
  if 指导小组名单 != none { 指导小组名单 = () }
  if 公开评阅人名单 != none { 公开评阅人名单 = () }
  答辩委员会名单 = ()
  致谢 = []
  简历和成果 = []
  指导教师评语 = []
  答辩委员会决议书 = []
}

//打包传递参数
#let other_contents = (
  系统性创新性: 系统性创新性,
  授权: 授权,
  指导小组名单: 指导小组名单,
  公开评阅人名单: 公开评阅人名单,
  答辩委员会名单: 答辩委员会名单,
  摘要: 摘要, 
  关键词: 关键词,
  摘要_英: 摘要_英, 
  关键词_英: 关键词_英,
  符号和缩略语: 符号和缩略语, 
  附录: 附录, 
  致谢: 致谢, 
  声明: 声明,
  简历和成果: 简历和成果, 
  指导教师评语: 指导教师评语, 
  答辩委员会决议书: 答辩委员会决议书,
  其他材料: 其他材料,
)



#[
  #set align(center+horizon)
  #set text(size: 40pt, font: settings.字体.黑体 ,fill: white)
  #set page(fill: eastern)
  
  您现在正在预览
  
  "设置与其他.typ"

  \
  
  请预览"正文.typ"

]