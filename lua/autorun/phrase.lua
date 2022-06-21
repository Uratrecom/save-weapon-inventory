if not file.Exists("phrase", "DATA") then
    file.CreateDir("phrase")
end

PhraseLanguageClass = PhraseLanguageClass or {}
PhraseLanguageClass.__index = PhraseLanguageClass

function PhraseLanguage(languageName)
    if languageName == nil then
        Error("Language name required")
    end

    local self = setmetatable({}, PhraseLanguageClass)

    self.name = languageName
    self.phrases = {}

    MsgC(
        Color(50, 139, 255),
        '[Phrase] Initialized language "',
        Color(50, 255, 245),
        self.name,
        Color(50, 139, 255),
        '" in space "',
        Color(50, 255, 77),
        self.space.name,
        Color(50, 139, 255),
        '"\n'
    )

    return self
end

function PhraseLanguageClass:phrase(phraseId, text)
    if phraseId and text then
        self.phrases[phraseId] = text
    elseif phraseId and text == nil then
        local ph = self.phrases[phraseId]

        if ph == nil then
            return phraseId
        end
    
        return ph
    end
end

function PhraseLanguageClass:phraseF(phraseId, args)
    local ph = self.phrases[phraseId]
    args = args or {}

    if ph == nil then
        return phraseId
    end

    for m in ph:gmatch("[^%{(.*)%}]+") do
        local arg

        if args[m] ~= nil then
            arg = args[m]
        elseif self:phrase(m) ~= m then
            arg = self:phrase(m)
        else
            arg = "{" .. m .. "}"
        end

        ph = ph:gsub("{" .. m .. "}", arg)
    end

    return ph
end

PhraseSpaceClass = PhraseSpaceClass or {}
PhraseSpaceClass.__index = PhraseSpaceClass

function PhraseSpace(name) 
    if name == nil then
        Error("Spacename required.")
    end

    local self = setmetatable({}, PhraseSpaceClass)

    table.insert(phrase.spaces, self)

    self.selectedLanguage = nil
    self.languages = {}
    self.name = name

    if file.Exists("phrase/" .. self.name .. ".dat", "DATA") then
        self.selectedLanguage(file.Read("phrase/" .. self.name .. ".dat", "DATA"))
    end

    MsgC(
        Color(50, 139, 255), 
        '[Phrase] Initialized space "',
        Color(50, 255, 77), 
        self.name,
        Color(50, 139, 255), 
        '"\n'
    )

    return self
end

function PhraseSpaceClass:languagePhrase(language, phraseId, text)
    local lang = self.languages[language]

    if lang == nil then
        return phraseId
    end

    if text then
        lang:phrase(phraseId, text)
    else
        return lang:phrase(phraseId)
    end
end

function PhraseSpaceClass:phrase(phraseId)
    if self.selectedLanguage == nil then
        return phraseId
    end

    return self:languagePhrase(self.selectedLanguage, phraseId)
end

function PhraseSpaceClass:phraseF(phraseId, args)
    local lang = self.languages[language]
    args = args or {}

    if lang == nil then
        return phraseId
    end

    return lang:phraseF(phraseId, args)
end

function PhraseSpaceClass:selectedLanguage(language)
    if language == nil then
        return self.selectedLanguage
    else
        self.selectedLanguage = language
        file.Write("phrase/" .. self.name .. ".dat", self.selectedLanguage)
    end
end