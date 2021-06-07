--- setup.py.orig	2021-05-28 02:40:44 UTC
+++ setup.py
@@ -202,6 +202,7 @@ if platform.system() == "Windows":
 else:
     setup(
         name="chiapos",
+        version="1.0.3",
         author="Mariano Sorgente",
         author_email="mariano@chia.net",
         description="Chia proof of space plotting, proving, and verifying (wraps C++)",
@@ -209,7 +210,7 @@ else:
         python_requires=">=3.7",
         long_description=open("README.md").read(),
         long_description_content_type="text/markdown",
-        url="https://github.com/Chia-Network/chiavdf",
+        url="https://github.com/Chia-Network/chiapos",
         ext_modules=[CMakeExtension("chiapos", ".")],
         cmdclass=dict(build_ext=CMakeBuild),
         zip_safe=False,
