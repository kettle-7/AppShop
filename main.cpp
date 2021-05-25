#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <stdio.h> // Needed by libcurl
#include <curl/curl.h>
#include <curl/easy.h>
#include <iostream> // Also needed by libcurl
#include <string> // Needed by libcurl
#include "main.h" // Not needed by libcurl, needed by QObject

// Code from https://stackoverflow.com/a/36401787/14031662
size_t CurlWrite_CallbackFunc_StdString(void *contents, size_t size, size_t nmemb, std::string *s)
{
    size_t newLength = size*nmemb;
    try
    {
        s->append((char*)contents, newLength);
    }
    catch(std::bad_alloc &e)
    {
        //handle memory problem
        return 0;
    }
    return newLength;
}

QString Curler::downloadFile(QString url) {
    CURL *curl;
    CURLcode res;
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    std::string s;
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.toStdString().c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, CurlWrite_CallbackFunc_StdString);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &s);
        /* res is the HTTP return code */
        res = curl_easy_perform(curl);
        /* Check if we're okay */
        if(res != CURLE_OK)
          fprintf(stderr, "Couldn't fetch file(s): %s\n",
                  curl_easy_strerror(res));

        /* Clean up */
        curl_easy_cleanup(curl);
    }
    return QString::fromStdString(s);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    qmlRegisterType<Curler>("io.github.linuxkettle.AppShop", 0, 1, "Curler");
    engine.load(url);
    return app.exec();
}
