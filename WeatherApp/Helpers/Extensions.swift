extension Double {
    var convertFromFahrenheitToCelsius: Double {
        return 5.0 / 9.0 * (self - 32.0)
    }
    
    var convertFromKelvinToCelsius: Double {
        return self - 273.15
    }
}
