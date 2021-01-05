;; Projectile Project for Visual Studio
(provide 'visual-studio-projectile)

(defconst VS_PATH "C:/Program Files (x86)/Microsoft Visual Studio/")
(defconst MSBUILD_NAME "MSBuild.exe")
(defvar possible_paths '(list
 "2019/Community/MSBuild/Current/Bin"
 "2017/Community/MSBuild/15.0/Bin"))

(defun msbuild-compile ()
  (locate-file "MSBuild.exe"
		    '("C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin"
		      "C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin"
		      )
  )
)
(projectile-register-project-type 'visual-studio '("*.sln" "*.vcxproj")
				  :project-file "*.sln"
				  :compile 'msbuild-compile
				  )
