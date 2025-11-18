# 1. Aşama: Build (Derleme)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Önce projeyi kopyala ve restore et (Cache mantığı için)
COPY src/*.csproj ./src/
WORKDIR /app/src
RUN dotnet restore

# Kalan dosyaları kopyala ve build al
COPY src/. .
RUN dotnet publish -c Release -o /out

# 2. Aşama: Runtime (Çalıştırma) - Daha küçük bir imaj kullanırız
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .

# Container 8080 portundan yayın yapacak
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "MyWebApp.dll"]