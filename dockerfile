FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 拷贝文件到容器
COPY package*.json ./
COPY . .

# 安装依赖
RUN npm install

# 构建 React 项目，默认输出到 dist/
RUN npm run build 
#-- --mode production

# 第二步：使用 nginx 作为 Web 服务器托管前端资源
FROM nginx:stable-alpine

# 删除默认 nginx 页面
RUN rm -rf /usr/share/nginx/html/*

# 拷贝构建好的前端文件到 nginx 的 html 目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 拷贝自定义 nginx 配置文件（可选，但推荐用于 SPA 路由处理）
#COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 80 端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]
