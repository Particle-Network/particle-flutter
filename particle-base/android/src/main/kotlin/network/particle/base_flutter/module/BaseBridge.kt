package network.particle.base_flutter.module


import android.app.Activity
import android.util.Log
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

import com.particle.base.CurrencyEnum
import com.particle.base.Env

import com.particle.base.LanguageEnum
import com.particle.base.ParticleNetwork
import com.particle.base.ParticleNetwork.setFiatCoin
import com.particle.base.ThemeEnum
import com.particle.base.data.CountryInfo

import com.particle.base.model.SecurityAccountConfig
import com.particle.base.utils.ChainUtils

import io.flutter.plugin.common.MethodChannel

import network.particle.base_flutter.model.BaseInitData
import network.particle.base_flutter.model.ChainData
import network.particle.chains.ChainInfo
import org.json.JSONObject


object BaseBridge {
    ///////////////////////////////////////////////////////////////////////////
    //////////////////////////// AUTH //////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    fun init(activity: Activity, initParams: String?) {
        LogUtils.d("init", initParams)
        val initData = GsonUtils.fromJson(initParams, BaseInitData::class.java)
        val chainInfo = ChainUtils.getChainInfo(initData.chainId)
        ParticleNetwork.init(activity, Env.valueOf(initData.env!!.uppercase()), chainInfo)
    }

    fun getLanguage(result: MethodChannel.Result) {
        val language = ParticleNetwork.getLanguage()
        LogUtils.d("getLanguage", language.toString())
        if (language == LanguageEnum.ZH_CN) {
            result.success("zh_hans")
        } else if (language == LanguageEnum.ZH_TW) {
            result.success("zh_hant")
        } else if (language == LanguageEnum.JA) {
            result.success("ja")
        } else if (language == LanguageEnum.KO) {
            result.success("ko")
        } else {
            result.success("en")
        }
    }

    fun setChainInfo(chainParams: String, result: MethodChannel.Result) {
        LogUtils.d("setChainName", chainParams)
        LogUtils.d("setChainName", chainParams)
        val chainData: ChainData = GsonUtils.fromJson(
            chainParams, ChainData::class.java
        )
        try {
            val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
            ParticleNetwork.setChainInfo(chainInfo)
            result.success(true)
        } catch (e: Exception) {
            LogUtils.e("setChainName", e.message)
            result.success(false)
        }
    }
    fun getChainInfo(result: MethodChannel.Result) {
        val chainInfo: ChainInfo = ParticleNetwork.chainInfo
        val map: MutableMap<String, Any> = HashMap()
        map["chain_name"] = chainInfo.name
        map["chain_id"] = chainInfo.id
        LogUtils.d("getChainInfo", Gson().toJson(map))
        result.success(Gson().toJson(map))
    }

    fun setSecurityAccountConfig(configJson: String) {
        LogUtils.d("setSecurityAccountConfig", configJson)
        try {
            val jobj = JSONObject(configJson)
            val promptSettingWhenSign = jobj.getInt("prompt_setting_when_sign")
            val promptMasterPasswordSettingWhenLogin =
                jobj.getInt("prompt_master_password_setting_when_login")
            val config = SecurityAccountConfig(
                promptSettingWhenSign, promptMasterPasswordSettingWhenLogin
            )
            ParticleNetwork.setSecurityAccountConfig(config)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun setLanguage(language: String) {
        LogUtils.d("setLanguage", language)
        if (language.isEmpty()) {
            return
        }
        if (language.equals("zh_hans")) {
            ParticleNetwork.setLanguage(LanguageEnum.ZH_CN)
        } else if (language.equals("zh_hant")) {
            ParticleNetwork.setLanguage(LanguageEnum.ZH_TW)
        } else if (language.equals("ja")) {
            ParticleNetwork.setLanguage(LanguageEnum.JA)
        } else if (language.equals("ko")) {
            ParticleNetwork.setLanguage(LanguageEnum.KO)
        } else {
            ParticleNetwork.setLanguage(LanguageEnum.EN)
        }
    }


    fun setAppearance(appearance: String) {
        LogUtils.d("setAppearance", appearance)
        ParticleNetwork.setAppearence(ThemeEnum.valueOf(appearance.uppercase()))
    }

    fun setFiatCoin(fiatCoin: String) {
        LogUtils.d("setFiatCoin", fiatCoin)
        ParticleNetwork.setFiatCoin(CurrencyEnum.valueOf(fiatCoin.uppercase()))
    }
    fun setUnsupportCountries(countriesJson: String) {
        LogUtils.d("countriesJson", countriesJson)
        val listType = object : TypeToken<List<String>>() {}.type
        val list: List<String> = GsonUtils.fromJson<List<String>?>(countriesJson, listType).map { it.lowercase() }
        ParticleNetwork.setCountryFilter { countryInfo ->
            countryInfo.code !in list
        }
    }
}
