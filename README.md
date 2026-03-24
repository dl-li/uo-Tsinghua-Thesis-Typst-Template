# T4 - Tsinghua Thesis Typst Template: 清华大学研究生学位论文Typst模板（非官方）
An unofficial Typst template for Tsinghua University (THU) graduate thesis.

本项目是清华大学研究生学位论文Typst模板，旨在规定论文各部分内容格式与样式，面向初学者详细介绍模板的使用方法，帮助研究生进行学位论文写作，降低编辑论文格式的不规范性和额外工作量。请注意，这是一个非官方的模板，请在使用前充分确认该模板符合院系要求。

  除常见自动排版功能外，本模板的特色功能包括:
  - `#tupian()`函数可以便捷地添加图片、图题、图注等，并防止跨页；
  - `#biaoge()`函数可以便捷地添加三线表并在跨页时自动生成续表题；
  - `#daima()`函数可以添加简单的代码块，并自动编号。
  
  如果有进阶的排版需求，请了解基于LaTeX的ThuThesis模板，这是一个非常成熟的模板，全面支持最新的本科、研究生、博士后论文/报告格式，获研究生院官方推荐。

  本项目受PKUTHSS-Typst和ThuThesis启发，并在PKUTHSS-Typst的基础上修改而来，格式大量参考了ThuWordThesis模板进行像素级对齐。项目使用了以下Typst包：`tablem`、`cuti`、`a2c-nums`、`modern-nju-thesis`。感谢开发者们的贡献。

## 使用方法

### A: from Typst Universe to Web APP
- 使用[本模板](https://typst.app/universe/package/uo-tsinghua-thesis)创建项目。首次打开可能较慢，请耐心等待
- 前往`设置与其他.typ`配置字体

注：只有大版本更新会同步Typst Universe，如果想要获取最新版，或需要修改模板样式，请前往GitHub/GitCode


### B: from GitHub/GitCode to Web APP
- 在GitHub上下载[Release](https://github.com/dl-li/uo-Tsinghua-Thesis-Typst-Template/releases)的Source Code
- 前往 Typst Web App 的 Dashboard 界面
- 创建新项目 + Empty document 或 Project - New Project
- 打开Web APP上的项目文件目录，拖拽上传`template`、`lib.typ`和自己下载的字体文件
- 静待所有文件上传完成
- 前往`设置与其他.typ`配置字体
- 点开template目录下`正文.typ`旁的眼睛图标，即可看到预览

[国内GitCode镜像](https://gitcode.com/dl-li/uo-Tsinghua-Thesis-Typst-Template)

### C: from GitHub/GitCode to Local Enviroment
- 面向有开发基础的用户，不再赘述


## 关于字体
本项目提供一系列开源字体，但是Windows版本的字体仍然是最佳选择，强烈建议替换。字体设置参见`template/设置与其他.typ`

## 博资考模板
本项目包含生医药博资考书面报告模板(英文，非官方)，但不在Typst Universe提供，请前往GitHub/GitCode仓库获取。本模板可能不常维护。

![thumbnail](/thumbnail.png)