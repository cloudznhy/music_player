#include "imagecolor.h"

ImageColor::ImageColor(QObject *parent) : QObject(parent)
{
}

ImageColor::ImageColor(const QImage &image, QObject *parent) : QObject(parent)
{
    this->avgColor(image);
}

double ImageColor::colorDistance(const QColor &c1, const QColor &c2)
{
    int dr = c1.red() - c2.red();
    int dg = c1.green() - c2.green();
    int db = c1.blue() - c2.blue();
    return std::sqrt(dr * dr + dg * dg + db * db);
}

QString ImageColor::avgColor(const QImage &image)
{
    qDebug() << "图片宽高" << "w: " << image.width() << " h: "<< image.height();
    // 初始化颜色值的总和
    int totalRed = 0;
    int totalGreen = 0;
    int totalBlue = 0;
    int totalPixels = image.width() * image.height();

    // 遍历图片像素，累加颜色值
    for (int y = 0; y < image.height(); ++y) {
        for (int x = 0; x < image.width(); ++x) {
            QColor color(image.pixel(x, y));
            totalRed += color.red();
            totalGreen += color.green();
            totalBlue += color.blue();
        }
    }

    // 计算平均颜色
    int avgRed = totalRed / totalPixels;
    int avgGreen = totalGreen / totalPixels;
    int avgBlue = totalBlue / totalPixels;

    // 创建平均颜色的 QColor 对象
    QColor avgColor(avgRed, avgGreen, avgBlue);

    // 输出平均颜色
    qDebug() << "Average color: " << avgColor.name();
    return avgColor.name();
}

// 选择初始聚类中心的 K-means++ 算法
QVector<QColor> ImageColor::kmeans_plusplus(const QImage& image, int k) {
    QVector<QColor> centroids;

    if (image.width() <= 0) return centroids;

    // 选择第一个聚类中心
    int x = QRandomGenerator::global()->bounded(image.width());
    int y = QRandomGenerator::global()->bounded(image.height());
    centroids.append(image.pixelColor(x, y));

    // 选择剩余的聚类中心
    for (int i = 1; i < k; ++i) {
        QVector<double> minDistances(image.width() * image.height(), std::numeric_limits<double>::max());
        double totalDist = 0.0;

        for (int y = 0; y < image.height(); ++y) {
            for (int x = 0; x < image.width(); ++x) {
                QColor pixel = image.pixelColor(x, y);
                for (int j = 0; j < centroids.size(); ++j) {
                    double d = colorDistance(pixel, centroids[j]);
                    minDistances[y * image.width() + x] = std::min(minDistances[y * image.width() + x], d);
                }
                totalDist += minDistances[y * image.width() + x];
            }
        }

        double randVal = QRandomGenerator::global()->bounded(totalDist);
        double sum = 0.0;
        x = 0;
        y = 0;
        for (y = 0; y < image.height(); ++y) {
            for (x = 0; x < image.width(); ++x) {
                sum += minDistances[y * image.width() + x];
                if (sum >= randVal) {
                    break;
                }
            }
            if (sum >= randVal) {
                break;
            }
        }

        centroids.append(image.pixelColor(x, y));
    }

    return centroids;
}

QVariantList ImageColor::getMainColors(const QImage &image) {
    QVariantList colorList;
    if (image.isNull()) {
        qWarning() << "Invalid image provided to getMainColors";
        return colorList;
    }

    // 执行K-means聚类
    QVector<QColor> centroids = kmeans_plusplus(image, m_k);
    QVector<int> clusterSizes(m_k, 0);

    // 迭代更新聚类中心
    for (int iter = 0; iter < 10; ++iter) {
        QVector<QVector<QColor>> clusters(m_k);
        clusterSizes.fill(0);

        for (int y = 0; y < image.height(); ++y) {
            for (int x = 0; x < image.width(); ++x) {
                QColor pixel = image.pixelColor(x, y);
                int closest = 0;
                double minDist = m_minDistance;
                for (int i = 0; i < centroids.size(); ++i) {
                    double dist = colorDistance(pixel, centroids[i]);
                    if (dist < minDist) {
                        minDist = dist;
                        closest = i;
                    }
                }
                clusters[closest].append(pixel);
                clusterSizes[closest]++;
            }
        }

        // 更新聚类中心
        for (int i = 0; i < m_k; ++i) {
            if (clusterSizes[i] == 0) continue;

            int r = 0, g = 0, b = 0;
            for (const QColor &color : clusters[i]) {
                r += color.red();
                g += color.green();
                b += color.blue();
            }
            r /= clusterSizes[i];
            g /= clusterSizes[i];
            b /= clusterSizes[i];
            centroids[i] = QColor(r, g, b);
        }
    }

    // 按亮度排序
    std::sort(centroids.begin(), centroids.end(), [](const QColor &a, const QColor &b) {
        return a.lightnessF() < b.lightnessF();
    });

    // 转换为QVariantList
    for (const QColor &color : centroids) {
        colorList.append(QVariant::fromValue(color));
    }

    return colorList;
}
