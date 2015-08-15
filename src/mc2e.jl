# mc2e computes energy from mel-cepstrum.
function mc2e(mc::AbstractVector, α=0.35, len=256)
    # back to linear frequency domain
    c = freqt(mc, len-1, -α)

    # compute impule response from cepsturm
    ir = c2ir(c, len)

    sumabs2(ir)
end

function mc2e(mc::AbstractMatrix, α=0.35, len=256)
    r = Array{T}(size(mc, 2))
    for i in 1:size(r, 2)
        r[i] = mc2e(sub(mc, :, i), α, len)
    end
    r
end

function mc2e{T<:MelCepstrum}(state::SpectralParamState{T}, len)
    assert_not_ready_to_filt(state)

    def = paramdef(state)
    α = allpass_alpha(def)
    data = rawdata(state)
    mc2e(data, α, len)
end
