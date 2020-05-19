# 指定Name
LibName="LWAspectsHook"

# framework
# pod package ${LibName}.podspec --force --configuration=Release

# .a
pod package ${LibName}.podspec --force --library --configuration=Release

# 获取版本号
version=`grep "s\.version\s\+=\s*'" ${LibName}.podspec | awk -F "'" '{print $2}'`

# 拷贝文件
libDir="../mybinlibs/${LibName}/${version}"
if [ ! -d "${libDir}" ]; then
  mkdir -p "${libDir}"
fi
cp -R "${LibName}-${version}/ios" "${libDir}/"
podspec_file="${libDir}/${LibName}.podspec"
cp "${LibName}-${version}/${LibName}.podspec" "${podspec_file}"

# 替换homepage
lowLibName=`echo "$LibName" | awk '{ print tolower($1) }'`
sed -i '' "s/\(s\.homepage = \)\".*\"/\1\"https:\/\/gitee\.com\/lw_ios_libs\/${lowLibName}\.git\"/" "${podspec_file}"

# 注释 s.ios.vendored_framework
sed -i '' "s/\(s\.ios\.vendored_framework\)/# \1/" "${podspec_file}"

# 追加 vendored_libraries
sed -i '' "s/^end$/  s\.ios\.vendored_libraries = \'ios\/lib${LibName}\.a\' #end/g" "${podspec_file}"
sed -i '' $'s/#end/\\\nend/g' "${podspec_file}"

# git 提交
if git diff-index --quiet HEAD --; then
    echo "无修改"
else
	echo "有修改"
	git add .
	msg_info="修改${LibName}"
	msg_random=`date +%F-%H%M%S`$(echo $RANDOM | tr '[0-9]' '[a-z]')
	git commit -am "$msg_info $msg_random" 
	git push origin master
fi
