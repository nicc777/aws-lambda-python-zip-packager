install:
	mkdir /usr/share/alpz
	mkdir /usr/lib/alpz
	cp -vf scripts/container_package_python_lambda_function.sh /usr/lib/alpz/
	cp -vf templates/python.Dockerfile /usr/share/alpz/
	cp -vf scripts/prepare_python_lambda_function_package.sh /usr/bin/alpz
	chmod 755 /usr/bin/alpz
	chmod 755 /usr/lib/alpz/*
	chmod 644 /usr/share/alpz/*

clean:
	rm -frRv /usr/share/alpz
	rm -frRv /usr/lib/alpz
	rm -fv /usr/bin/alpz