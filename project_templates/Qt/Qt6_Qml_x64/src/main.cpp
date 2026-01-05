#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtDebug>

int main( int argc, char* argv[] )
{
	qDebug() << "running" << Qt::endl;
	QGuiApplication		  app( argc, argv );
	QQmlApplicationEngine engine;
	const QUrl			  url( QStringLiteral( "qrc:/qm/m.qml" ) );

	// 打印加载的QML文件路径
	qDebug() << "Loading QML file:" << url;

	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreated, &app,
		[ url ]( QObject* obj, const QUrl& objUrl )
		{
			if ( !obj && url == objUrl )
			{
				// 添加更多的调试信息
				qDebug() << "Failed to create object from" << url;
				QCoreApplication::exit( -1 );
			}
			else
			{
				qDebug() << "Object created successfully from" << url;
			}
		},
		Qt::QueuedConnection );

	if ( !engine.rootContext() )
	{
		qDebug() << "Error: QQmlApplicationEngine root context is null.";
		return -1;
	}

	engine.load( url );

	if ( engine.rootObjects().isEmpty() )
	{
		qDebug() << "Failed to load QML file:" << url;
		return -1;
	}
	else
	{
		qDebug() << "QML file loaded successfully:" << url;
	}
	return app.exec();
}
