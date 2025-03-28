import cv2
import numpy as np

def measure_stripes_distance(image_path):
    # 读取图像
    image = cv2.imread(image_path)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # 应用高斯模糊去噪声
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # 自适应阈值处理
    adaptive_thresh = cv2.adaptiveThreshold(blurred, 255, 
                                            cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                            cv2.THRESH_BINARY, 11, 2)

    # 应用边缘检测
    edges = cv2.Canny(adaptive_thresh, 50, 150, apertureSize=3)

    # 使用霍夫变换检测直线
    lines = cv2.HoughLines(edges, 1, np.pi / 90,100)

    # 如果检测到线条
    if lines is not None:
        distances = []
        for line in lines:
            rho, theta = line[0]
            a = np.cos(theta)
            b = np.sin(theta)
            x0 = a * rho
            y0 = b * rho
            x1 = int(x0 + 1000 * (-b))
            y1 = int(y0 + 1000 * (a))
            x2 = int(x0 - 1000 * (-b))
            y2 = int(y0 - 1000 * (a))
            cv2.line(image, (x1, y1), (x2, y2), (0, 255, 0), 2)

            # 记录条纹的坐标
            distances.append((x1, y1))

        # 计算相邻条纹的间距
        if len(distances) > 1:
            stripe_distances = []
            for i in range(1, len(distances)):
                distance = np.sqrt((distances[i][0] - distances[i - 1][0]) ** 2 +
                                   (distances[i][1] - distances[i - 1][1]) ** 2)
                stripe_distances.append(distance)
                print(f"Distance between stripe {i-1} and {i}: {distance:.2f} pixels")

                # 在图像上标注距离
                midpoint = ((distances[i][0] + distances[i - 1][0]) // 2,
                             (distances[i][1] + distances[i - 1][1]) // 2)
                cv2.putText(image, f"{distance:.2f}px", midpoint, 
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 1)

        # 显示结果图像
        cv2.imshow("Detected Stripes", image)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
    else:
        print("No stripes detected.")

# 示例用法
measure_stripes_distance(r'D:\A\VScode\Stripe\33.png')
