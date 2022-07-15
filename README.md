### odev-3
1. Veritabanı oluştur(tablolar konusunda tamamen serbestsin)
2. Oluşturduğun veritabanına uygun verileri ekle
3. Geriye en az 1 tablo döndüren ve 1 değer döndüren fonksiyon oluştur
4. En az 1 tane stored procedure oluştur
5. Script çıkar
6. Ödev için açılacak repository içerisine 15 temmuz saat 23.00'a kadar yükle

# Son Teslim Tarihi: 15/07/2022 23:00

## TÖDEB'E BAĞLI KURULUŞLARI İÇEREN VERİTABANI PROJESİ
#### TÖDEB'te 2 kategori vardır: 1. Elektronik Para Kuruluşları, 2. Ödeme Kuruluşları
### Projede Todeb adında veritabanı oluşturulmuştur ve içerisinde 4 adet tablo mevcuttur. Bu tablolar birbirine Primary-Foreign Key ilişkisi ile bağlıdır:
#### 1. Companies ( Kuruluşlar) => İçerisinde şirket ismi, kategorisi, Tödeb'e kayıt tarihi, bağlı olduğu şehir, web sitesi sütunları oluşturulmuştur.
#### 2. CompanyDetails (Kuruluşların Detayları) => İçerisinde Şirket adresi, kuruluş tarihi, telefon, işlem komisyon oranı ve üst işlem limiti sütunları vardır.
## (Tarihler, komisyon oranları ve üst işlem limit değerlerine örnek olması açısından RASTGELE değerler atanmıştır!!!)
#### 3. Cities (Şehirler) => Her bir şehrin plaka kodları id olarak atanmıştır.
#### 4. Categories (Kategoriler) => 1. kategori Elektronik Para ; 2. kategori Ödeme olarak atanmıştır.

### Projede 1 adet VİEW, 5 adet Table-Valued Fonksiyon, 2 adet Scalar-Valued Fonksiyon ve 2 adet Stored Procedure kullanılmıştır.

### Veritabanının Görseller İle Açıklanması:

1. Companies Tablosu
![1](https://user-images.githubusercontent.com/99509540/179297987-b340bb7f-c04c-42d3-92ef-cd17e9fc9865.png)

2. CompanyDetails Tablosu
![2](https://user-images.githubusercontent.com/99509540/179298045-2eab697b-2be9-469a-8c34-296b925de794.png)

3. Categories Tablosu
![3](https://user-images.githubusercontent.com/99509540/179298122-c002fe2a-378a-4409-9912-3bada276a446.png)

4. Cities Tablosu
![4](https://user-images.githubusercontent.com/99509540/179298158-f0ba3c58-087d-462a-b377-c5ca92ae9a85.png)


5. Veritabanı Diyagramı
![Diyagram](https://user-images.githubusercontent.com/99509540/179298222-cdbc74d7-36ac-405e-9d3a-e984ab51332a.png)

6. TODEBComnaniesAndDetails View'inin Çıktısı
![5ViewEkranGoruntusu](https://user-images.githubusercontent.com/99509540/179298338-0dfde471-7b85-4647-8adc-2e49f0801084.png)

7. CompanyDetails Fonksiyonunun Çıktısı
![6CompanyDetailsEkranFotografi](https://user-images.githubusercontent.com/99509540/179298466-ac279113-a656-42b2-932b-b6e07ce1a1fa.png)

8. Elektronik Para Kuruluşlarını Gösteren Fonksiyon
![7ElektronikParaKuruluslariniGosteren](https://user-images.githubusercontent.com/99509540/179298601-3285dea6-1497-4da2-87be-2541e15afada.png)

9. Ödeme Kuruluşlarını Gösteren Fonksiyon
![8OdemeKuruluslariniGosteren](https://user-images.githubusercontent.com/99509540/179298647-6db06956-bc43-4cc6-9249-78b54c73cd96.png)

10. Girilen Komisyon Oranina Sahip Kurulusları Gosteren Fonksiyon
![9GirilenKomisyonOraninaSahipKuruluslariGosteren](https://user-images.githubusercontent.com/99509540/179298756-161f640d-0a03-4665-97d0-74cff4a61144.png)

11. Girilen Miktar ve Üstünde Üst İşlem Limitine Sahip Kuruluşları Gösteren Fonksiyon
![10GirilenLimitveUstuneSahipKuruluslariGosteren](https://user-images.githubusercontent.com/99509540/179299121-75eee05c-eea4-4749-b334-47951e25685a.png)

12. Girilen Miktar ve Seçilen Kuruluşa Göre Toplam Maliyeti Gösteren Fonksiyon 
![11GirilenMiktaraGoreIstenilenKurulustaIsleminMaliyeti](https://user-images.githubusercontent.com/99509540/179298935-c319f0e1-0dde-44a6-ac79-1506d2f344d2.png)

13. Komisyon Oranını Değiştiren Stored Procedure
![12KomisyonOraniniDegistirenVeYeniVeriyiGosteren (2)](https://user-images.githubusercontent.com/99509540/179299008-405d2847-2044-4325-b8af-207df465db9f.png)

14. İşlem Üst Limitini Değiştiren Stored Procedure
![13İşlemLimitiniDegistirenVeYeniVeriyiGosteren](https://user-images.githubusercontent.com/99509540/179299199-4b1c4829-6325-4633-9651-fb31a590b9c0.png)

15. Girilen Miktara Göre Her Kuruluştaki Komisyon Ücretlerinin Eklenerek Her Birinin Maliyetini Gösteren Fonksiyon
![14GirilenMiktaraGöreHerKuruluştakiToplamMaliyetiGosteren](https://user-images.githubusercontent.com/99509540/179299316-1b4ea3e3-d9be-4420-8560-baaf07fd3df5.png)
























