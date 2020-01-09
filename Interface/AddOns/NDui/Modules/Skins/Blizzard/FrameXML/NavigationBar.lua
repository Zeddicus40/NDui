local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.themes["AuroraClassic"], function()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	local r, g, b = DB.r, DB.g, DB.b

	local function moveNavButtons(self)
		local width = 0
		local collapsedWidth
		local maxWidth = self:GetWidth() - self.widthBuffer

		local lastShown
		local collapsed = false

		for i = #self.navList, 1, -1 do
			local currentWidth = width
			width = width + self.navList[i]:GetWidth()

			if width > maxWidth then
				collapsed = true
				if not collapsedWidth then
					collapsedWidth = currentWidth
				end
			else
				if lastShown then
					self.navList[lastShown]:SetPoint("LEFT", self.navList[i], "RIGHT", 1, 0)
				end
				lastShown = i
			end
		end

		if collapsed then
			if collapsedWidth + self.overflowButton:GetWidth() > maxWidth then
				lastShown = lastShown + 1
			end

			if lastShown then
				local lastButton = self.navList[lastShown]

				if lastButton then
					lastButton:SetPoint("LEFT", self.overflowButton, "RIGHT", 1, 0)
				end
			end
		end
	end

	hooksecurefunc("NavBar_Initialize", B.ReskinNavBar)

	hooksecurefunc("NavBar_AddButton", function(self)
		B.ReskinNavBar(self)

		local navButton = self.navList[#self.navList]
		if not navButton.restyled then
			B.Reskin(navButton)
			navButton.arrowUp:SetAlpha(0)
			navButton.arrowDown:SetAlpha(0)
			navButton.selected:SetDrawLayer("BACKGROUND", 1)
			navButton.selected:SetColorTexture(r, g, b, .25)
			navButton.selected:SetAllPoints(navButton.bgTex)

			navButton:HookScript("OnClick", function()
				moveNavButtons(self)
			end)

			-- arrow button
			local arrowButton = navButton.MenuArrowButton
			arrowButton.Art:Hide()
			arrowButton:SetHighlightTexture("")

			local tex = arrowButton:CreateTexture(nil, "ARTWORK")
			tex:SetTexture(DB.arrowDown)
			tex:SetSize(8, 8)
			tex:SetPoint("CENTER")
			arrowButton.bgTex = tex

			local colourArrow, clearArrow = B.colourArrow, B.clearArrow
			arrowButton:SetScript("OnEnter", colourArrow)
			arrowButton:SetScript("OnLeave", clearArrow)

			navButton.restyled = true
		end

		moveNavButtons(self)
	end)
end)